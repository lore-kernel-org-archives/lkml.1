Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYKKVHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYKKVHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKKVG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:06:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYKKVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:06:57 -0500
Date: Tue, 11 Nov 2008 16:06:43 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       srostedt@redhat.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/1] ring-buffer: buffer record on/off switch
In-Reply-To: <20081111125645.4f7a5827.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811111606040.3275@gandalf.stny.rr.com>
References: <20081111200601.147669239@goodmis.org> <20081111201034.315528609@goodmis.org> <20081111125645.4f7a5827.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Added Andy on Cc ]

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

I wonder if this should be added to checkpatch?

-- Steve

