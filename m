Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZKNUoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZKNUoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 15:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZKNUoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 15:44:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53738 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZKNUo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 15:44:29 -0500
Subject: Re: + recordmcount-stfu.patch added to -mm tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, lihong.hi@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091114092718.GA10969@elte.hu>
References: <200911140356.nAE3utfU001939@imap1.linux-foundation.org>
	 <1258174705.22249.236.camel@gandalf.stny.rr.com>
	 <20091113212645.3956bc85.akpm@linux-foundation.org>
	 <1258176822.22249.239.camel@gandalf.stny.rr.com>
	 <20091114092718.GA10969@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 14 Nov 2009 15:44:26 -0500
Message-Id: <1258231467.22249.438.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-14 at 10:27 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 2009-11-13 at 21:26 -0800, Andrew Morton wrote:
> > 
> > > Dunno, really.  How many people are running old objdump, and do we 
> > > want to retard the rate at which the stragglers will upgrade?
> > 
> > I guess not, but by printing out a warning 
> > 1000000000000000000000000000 times per build, it may encourage them to 
> > upgrade ;-)
> 
> If that binutils version is still supported this is not the right 
> method. People are in their full rights to be at any version within the 
> supported versions interval, and we should not 'force' them.

It's not forcing them. The patch I posted gave a way to disable that
warning.

But I agree with Andrew, the correct approach is to have it warn just
once. The posted patch was just an easier approach.

-- Steve


