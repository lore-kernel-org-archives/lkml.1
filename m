Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYKKVEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYKKVEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKKVEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:04:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36480 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYKKVEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:04:38 -0500
Date: Tue, 11 Nov 2008 16:04:36 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, srostedt@redhat.com
Subject: Re: [PATCH 1/1] ring-buffer: buffer record on/off switch
In-Reply-To: <20081111125645.4f7a5827.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811111603590.3275@gandalf.stny.rr.com>
References: <20081111200601.147669239@goodmis.org> <20081111201034.315528609@goodmis.org> <20081111125645.4f7a5827.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Nov 2008, Andrew Morton wrote:

> On Tue, 11 Nov 2008 15:06:02 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +static struct file_operations rb_simple_fops = {
> 
> should be const...
> 
> Probably it isn't worth fixing.  Someone(tm) should do period sweeps -
> 10% of our file_operationses aren't const.

Thanks, I never really thought about it.

I'll add to my todo list to send out a patch that cleans all of this up. I 
think I'm guilty at doing this in more than one place.

-- Steve

