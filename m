Return-Path: <linux-kernel-owner+w=401wt.eu-S1762118AbYEMVd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762118AbYEMVd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759886AbYEMVdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:33:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4123 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761340AbYEMVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:33:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QGHbGfvFgT+MTzW0NGhV8wAxMvznc4io1Wq+zN2dLR84oQZP3OuRrHACjUM+cKwrA
	3wPYmOQ5jcbc1f4ArWGfg==
Message-ID: <6599ad830805131432h6ea6b962v2405421c61fe88e5@mail.gmail.com>
Date: Tue, 13 May 2008 14:32:57 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 3/8]: CGroup Files: Move the release_agent file to use typed handlers
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <20080513130833.cc03caea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513063707.049448000@menage.corp.google.com>
	 <20080513071522.470099000@menage.corp.google.com>
	 <20080513130833.cc03caea.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 1:08 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 12 May 2008 23:37:10 -0700
>  menage@google.com wrote:
>
>  > +             agentbuf = kmalloc(PATH_MAX, GFP_KERNEL);
>  > +             if (!agentbuf)
>  > +                     goto continue_free;
>  > +             strcpy(agentbuf, cgrp->root->release_agent_path);
>
>  Did we need to allocate all that memory, or would kstrdup() suffice?
>

kstrdup() would be fine. Fixed.

Paul
