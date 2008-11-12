Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYKLOL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYKLOL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 09:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYKLOLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 09:11:20 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50249 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYKLOLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 09:11:20 -0500
Date: Wed, 12 Nov 2008 14:11:13 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, srostedt@redhat.com
Subject: Re: [PATCH 1/1] ring-buffer: buffer record on/off switch
Message-ID: <20081112141113.GG8302@shadowen.org>
References: <20081111200601.147669239@goodmis.org> <20081111201034.315528609@goodmis.org> <20081111125645.4f7a5827.akpm@linux-foundation.org> <alpine.DEB.1.10.0811111603590.3275@gandalf.stny.rr.com> <20081111210831.GA16179@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111210831.GA16179@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 10:08:31PM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Tue, 11 Nov 2008, Andrew Morton wrote:
> > 
> > > On Tue, 11 Nov 2008 15:06:02 -0500
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > +static struct file_operations rb_simple_fops = {
> > > 
> > > should be const...
> > > 
> > > Probably it isn't worth fixing.  Someone(tm) should do period sweeps -
> > > 10% of our file_operationses aren't const.
> > 
> > Thanks, I never really thought about it.
> > 
> > I'll add to my todo list to send out a patch that cleans all of this 
> > up. I think I'm guilty at doing this in more than one place.
> 
> Perhaps checkpatch.pl could remind us about it? a new file_operations 
> struct definition should be const in 99.9% of the cases.

Added to my TODO list.

-apw
