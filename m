Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZKNJ1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZKNJ1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZKNJ1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:27:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbZKNJ1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:27:23 -0500
Date: Sat, 14 Nov 2009 10:27:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lihong.hi@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + recordmcount-stfu.patch added to -mm tree
Message-ID: <20091114092718.GA10969@elte.hu>
References: <200911140356.nAE3utfU001939@imap1.linux-foundation.org>
 <1258174705.22249.236.camel@gandalf.stny.rr.com>
 <20091113212645.3956bc85.akpm@linux-foundation.org>
 <1258176822.22249.239.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258176822.22249.239.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2009-11-13 at 21:26 -0800, Andrew Morton wrote:
> 
> > Dunno, really.  How many people are running old objdump, and do we 
> > want to retard the rate at which the stragglers will upgrade?
> 
> I guess not, but by printing out a warning 
> 1000000000000000000000000000 times per build, it may encourage them to 
> upgrade ;-)

If that binutils version is still supported this is not the right 
method. People are in their full rights to be at any version within the 
supported versions interval, and we should not 'force' them.

	Ingo
