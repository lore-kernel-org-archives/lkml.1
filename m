Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbZLDOQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbZLDOQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbZLDOQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:16:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbZLDOQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:16:10 -0500
Subject: Re: [RFC PATCH] tracing - moving some of recordmcount
 functionality to binary
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
       jreiser@bitwagon.com
In-Reply-To: <1259934945-18305-1-git-send-email-jolsa@redhat.com>
References: <1259934945-18305-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 04 Dec 2009 09:16:14 -0500
Message-Id: <1259936174.12870.155.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 14:55 +0100, Jiri Olsa wrote:
> hi,
> 
> I noticed on some discussion, that it might speedup the FTRACE build process,
> if some of the 'scripts/recordmcount.pl' functionality was done in binary,
> instead of in the script using nm/.objdump output.
> 
> 
> Before I dive into details, to sum it up:
> - i wrote tool which took over some of the 'recordmcount.pl' stuff
> - with 'allyesconfig' the build was faster about 2 minutes
> 
> I'm not sure wether it's worth to continue in this effort,
> but I at least provide some details to have some enclosure.. :)

Actually, John Reiser sent me code a while back to convert the entire
shebang. I like that approach better. I actually just started looking at
it again recently.

The code will need libelf library, and may be arch specific (maybe not).
But if the current system can't compile it or use the binary, I was
going to have the make system default back to the perl script.

I rather keep the perl script intact, and just have an alternative
binary in case that doesn't work.

John,

I haven't touched the code (just dabbled with it). You can post it again
if you want, or I can if you can't find it.

-- Steve


