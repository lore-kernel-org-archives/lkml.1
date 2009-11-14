Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZKNFdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZKNFdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 00:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZKNFdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 00:33:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63267 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbZKNFdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 00:33:38 -0500
Subject: Re: + recordmcount-stfu.patch added to -mm tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lihong.hi@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091113212645.3956bc85.akpm@linux-foundation.org>
References: <200911140356.nAE3utfU001939@imap1.linux-foundation.org>
	 <1258174705.22249.236.camel@gandalf.stny.rr.com>
	 <20091113212645.3956bc85.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 14 Nov 2009 00:33:42 -0500
Message-Id: <1258176822.22249.239.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 21:26 -0800, Andrew Morton wrote:

> Dunno, really.  How many people are running old objdump, and do we want
> to retard the rate at which the stragglers will upgrade?

I guess not, but by printing out a warning 1000000000000000000000000000
times per build, it may encourage them to upgrade ;-)

> 
> I tend to be a late adopter ;) (for legit reasons, really - to catch
> things like this) so I'd be OK carrying that patch locally.
> 
> 
> Emitting that warning 1000000000000000000000000000 times per build is a
> bit obnoxious.  Maybe find some way to restrict it to once per `make'?
> 

I was originally going to do that, but then realized that he given patch
was easier to implement. I guess I can make a temp file that gets
deleted at the start of the build, and created the first time the
warning appears. Then the existence of that file will prevent other
warnings.

I'll play with this on Monday (if I remember ;-)

-- Steve


