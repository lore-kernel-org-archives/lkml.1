Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZBEPzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZBEPzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZBEPyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:54:54 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:34126 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176AbZBEPyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:54:53 -0500
Date: Thu, 5 Feb 2009 10:54:52 -0500
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing unistd_no.h and unistd_mm.h export on m68k
Message-ID: <20090205155452.GN26064@csclub.uwaterloo.ca>
References: <20090204181453.GE26064@csclub.uwaterloo.ca> <20090204183142.GF26064@csclub.uwaterloo.ca> <20090204184659.GG26064@csclub.uwaterloo.ca> <20090205055337.GA30333@uranus.ravnborg.org> <20090205155104.GM26064@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205155104.GM26064@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 10:51:04AM -0500, Lennart Sorensen wrote:

Oops, I forgot to do one of the requested fixes to the patch.

Here is a better one.

-- 
Len Sorensen

The header files exported on m68k are missing dependant header files
that are included by some of the epxorted files.  This includes the 8
missing pairs of files needed by normal and uclibc builds against the
headers files.

Signed-of-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 1a922fa..d477927 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -1,2 +1,18 @@
 include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
+header-y += param_mm.h
+header-y += param_no.h
+header-y += ptrace_mm.h
+header-y += ptrace_no.h
+header-y += setup_mm.h
+header-y += setup_no.h
+header-y += sigcontext_mm.h
+header-y += sigcontext_no.h
+header-y += siginfo_mm.h
+header-y += siginfo_no.h
+header-y += signal_mm.h
+header-y += signal_no.h
+header-y += swab_mm.h
+header-y += swab_no.h
+header-y += unistd_mm.h
+header-y += unistd_no.h
