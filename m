Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbXECTAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbXECTAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376302AbXECTAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:00:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbXECTAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:00:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=J+UsErstShvmWyMyR7Qs6hcR+H/uX9ni3ZSzQCvpuoOYAZEegM22IHWL378zIqSNN
	2eJnKwte7EnzTuwqpejWQ==
Date: Thu, 3 May 2007 11:56:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Adrian Bunk <bunk@stusta.de>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <20070503175125.GL3531@stusta.de>
Message-ID: <Pine.LNX.4.64.0705031154310.2312@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <1178084403.28659.222.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
 <1178087393.28659.238.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
 <1178089444.28659.246.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com>
 <20070502145550.GE3531@stusta.de> <20070502150546.GF3531@stusta.de>
 <Pine.LNX.4.64.0705021014070.3033@chino.kir.corp.google.com>
 <20070503175125.GL3531@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Adrian Bunk wrote:

> > That's only addressing part of the issue.  What about automatic or static 
> > external variables that are declared but may go unreferenced depending on 
> 
> This is only about static code. For non-static code it would be
> impossible for gcc to issue warnings.
> 

static external variables are certainly still static code and gcc issues 
the proper warnings if I do:

	static struct bootnode nodes[MAX_NUMNODES];

and I never reference nodes.
