Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbYD2Vr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbYD2Vr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYD2VrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:47:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:47890 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYD2VrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WZYmfpdMLAseUsrquAzo80i+24jU4VNc4JLOviXrxBhvBf1hS2uSmvv9Cc/im56UDkYTAXhiAFlhAALbPmdbEn1KRXpjuuv8NzVQP/ZlY3jLJXPdkr2aBHFd1jEr0LcRlcpFzUmxkSANTehaBJzXf1TrAPRFHxgZTWAjrVri4NU=
Message-ID: <7c86c4470804291447w713934a7o2b8a5a690fc9a535@mail.gmail.com>
Date: Tue, 29 Apr 2008 23:47:17 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25 new perfmon kernel patch + libpfm + pfmon available
Cc: ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <7c86c4470804291446l4693b317ha7ee2382d00e99e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470804291446l4693b317ha7ee2382d00e99e6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

 I have released the perfmon2 kernel patch for kernel v2.6.25. There is
 no major features. However, there were a major restructuring of the code
 to make it more readable, isolate features per module. The header files
 have also been restructured to separate user vs. kernel, and generic only
 vs. shared with arch. The restructuring of the interrupt handler yielded
 a nice 15% latency improvement on single counter sampling runs on X86.
 This new structure will make it easier to extract features and merge them
 with the mainline kernel.

 In the time frame of 2.6.26, I will push a few bits and pieces to LKML
 for final review and integration.

 Here are some of the kernel changes:
  - Cell updates (Carl Love, Takashi Yamamoto)
  - new perfmon_debug boot option to enable debug (Robert Richter)
  - several bugs fixes on Itanium, MIPS and generic hrtimer management
  - Power locking updates (Corey Ashford)

 There is also a new release for libpfm, now at version 3.4.
 The changes include:
  - AMD Phenom (a.k.a. Barcelona) IBS support (Robert Richter)
  - Python bindings and examples (Arun Sharma)
  - environment variable support to enable debugging
  - auto-detection of syscall base number for 2.6.24 and 2.6.25
  - new multi-threaded self-sampling example (Mark W. Krentel)
  - man pages cleanups (Steve Kaufmann)

 Special thanks to Arun (Google). The Python bindings are a nice addition
 to libpfm especially for prototyping and writing testsuites.

 Finally, a new major version of pfmon, now at pfmon-3.4.
 Among the many changes:
  - added support for dmalloc (Andrzej Nowak)
  - updated support for Cell processor (Takashi Yamamoto)
  - possibility to terminate pfmon cleanly with SIGTERM
  - --follow-fork and derivatives fixed on Itanium and other platforms
  - tracking of dlopen now works on mixed ABI environments
  - lots of bugs fixes

 As usual all files and more detailed changelogs can be downloaded from our
 website at:

        http://perfmon.sourceforge.net

 Enjoy,
