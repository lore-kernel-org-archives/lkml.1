Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXFVPai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXFVPai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbXFVPab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:30:31 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33379 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282AbXFVPaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:30:30 -0400
Date: Fri, 22 Jun 2007 08:30:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] CONFIG_PARAVIRT and CONFIG_MCOUNT don't play well
	together
Message-ID: <20070622153021.GR3723@sequoia.sous-sol.org>
References: <20070622080634.GP3723@sequoia.sous-sol.org> <1182516222.5493.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182516222.5493.33.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> Chris, thanks a hell of a lot for looking into this!!!
> 
> -rt doesn't do much with paravirt, but since both -rt and lguest are two
> things I love to play with, it was really bothering me that they were
> not getting along.

It was bugging me too, now if only I had noticed the compiler warnings ;-)
