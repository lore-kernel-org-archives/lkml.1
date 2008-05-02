Return-Path: <linux-kernel-owner+w=401wt.eu-S935786AbYEBQB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935786AbYEBQB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935557AbYEBQBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:01:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:15677 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbYEBQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PwB2hgJ2td/5x9Eoy22cCHwJtu0P9E7mQEYrm0GOzyCwO4aahZAtiP46yVwnG9rR1mfFJDGGQ6sjgtbOYXu8UYhBTtNVa1dfEqgTjwNM1U51546y83xH54h9hgOC9eDoNwa/CmDtpu0uGZbSu0Zg82pyKrCvB0BGUWimqfxTT68=
Message-ID: <7c86c4470805020901v57ea92a1p1e8d07be87c35dcb@mail.gmail.com>
Date: Fri, 2 May 2008 18:01:06 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 new perfmon kernel patch + libpfm + pfmon available
Cc: ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <7c86c4470804291447w713934a7o2b8a5a690fc9a535@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470804291446l4693b317ha7ee2382d00e99e6@mail.gmail.com>
	 <7c86c4470804291447w713934a7o2b8a5a690fc9a535@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


Several people noticed there was a typo in the website url.
The actual web site is:

      http://perfmon2.sf.net


Sorry about that.

On Tue, Apr 29, 2008 at 11:47 PM, stephane eranian
<eranian@googlemail.com> wrote:
>
> Hello,
>
>   I have released the perfmon2 kernel patch for kernel v2.6.25. There is
>   no major features. However, there were a major restructuring of the code
>   to make it more readable, isolate features per module. The header files
>   have also been restructured to separate user vs. kernel, and generic only
>   vs. shared with arch. The restructuring of the interrupt handler yielded
>   a nice 15% latency improvement on single counter sampling runs on X86.
>   This new structure will make it easier to extract features and merge them
>   with the mainline kernel.
>
>   In the time frame of 2.6.26, I will push a few bits and pieces to LKML
>   for final review and integration.
>
>   Here are some of the kernel changes:
>   - Cell updates (Carl Love, Takashi Yamamoto)
>   - new perfmon_debug boot option to enable debug (Robert Richter)
>   - several bugs fixes on Itanium, MIPS and generic hrtimer management
>   - Power locking updates (Corey Ashford)
>
>   There is also a new release for libpfm, now at version 3.4.
>   The changes include:
>   - AMD Phenom (a.k.a. Barcelona) IBS support (Robert Richter)
>   - Python bindings and examples (Arun Sharma)
>   - environment variable support to enable debugging
>   - auto-detection of syscall base number for 2.6.24 and 2.6.25
>   - new multi-threaded self-sampling example (Mark W. Krentel)
>   - man pages cleanups (Steve Kaufmann)
>
>   Special thanks to Arun (Google). The Python bindings are a nice addition
>   to libpfm especially for prototyping and writing testsuites.
>
>   Finally, a new major version of pfmon, now at pfmon-3.4.
>   Among the many changes:
>   - added support for dmalloc (Andrzej Nowak)
>   - updated support for Cell processor (Takashi Yamamoto)
>   - possibility to terminate pfmon cleanly with SIGTERM
>   - --follow-fork and derivatives fixed on Itanium and other platforms
>   - tracking of dlopen now works on mixed ABI environments
>   - lots of bugs fixes
>
>   As usual all files and more detailed changelogs can be downloaded from our
>   website at:
>
>         http://perfmon.sourceforge.net
>
>   Enjoy,
>
