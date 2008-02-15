Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbYBOGfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbYBOGfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbYBOGfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:35:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:36021 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYBOGfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:35:31 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] move wakeup code to .c
Date: Fri, 15 Feb 2008 01:35:06 -0500
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, hpa@zytor.com,
       rjw@sisk.pl, sam@ravnborg.org
References: <20080210222723.GA1865@elf.ucw.cz>
In-Reply-To: <20080210222723.GA1865@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802150135.07127.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/checkpatch.pl
ERROR: do not initialise externals to 0 or NULL
#113: FILE: arch/x86/boot/video-mode.c:29:
+int do_restore = 0;    /* Screen contents changed during mode flip */

WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
#644: FILE: arch/x86/kernel/acpi/realmode/wakemain.c:4:
+extern volatile struct wakeup_header wakeup_header;

WARNING: externs should be avoided in .c files
#644: FILE: arch/x86/kernel/acpi/realmode/wakemain.c:4:
+extern volatile struct wakeup_header wakeup_header;

ERROR: need a space before the open parenthesis '('
#710: FILE: arch/x86/kernel/acpi/realmode/wakemain.c:70:
+               while(1);

WARNING: externs should be avoided in .c files
#968: FILE: arch/x86/kernel/acpi/sleep.c:21:
+extern char wakeup_code_start, wakeup_code_end;

WARNING: externs should be avoided in .c files
#970: FILE: arch/x86/kernel/acpi/sleep.c:23:
+extern unsigned long setup_trampoline(void);

WARNING: externs should be avoided in .c files
#971: FILE: arch/x86/kernel/acpi/sleep.c:24:
+extern void wakeup_long64(void);

WARNING: externs should be avoided in .c files
#973: FILE: arch/x86/kernel/acpi/sleep.c:26:
+extern unsigned long saved_video_mode;

WARNING: externs should be avoided in .c files
#974: FILE: arch/x86/kernel/acpi/sleep.c:27:
+extern long saved_magic;

WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
#975: FILE: arch/x86/kernel/acpi/sleep.c:28:
+extern volatile unsigned long init_rsp;

WARNING: externs should be avoided in .c files
#975: FILE: arch/x86/kernel/acpi/sleep.c:28:
+extern volatile unsigned long init_rsp;

WARNING: externs should be avoided in .c files
#976: FILE: arch/x86/kernel/acpi/sleep.c:29:
+extern void (*initial_code)(void);

WARNING: externs should be avoided in .c files
#978: FILE: arch/x86/kernel/acpi/sleep.c:31:
+extern int wakeup_pmode_return;

WARNING: externs should be avoided in .c files
#979: FILE: arch/x86/kernel/acpi/sleep.c:32:
+extern char swsusp_pg_dir[PAGE_SIZE];

WARNING: externs should be avoided in .c files
#984: FILE: arch/x86/kernel/acpi/sleep.c:37:
+extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));

total: 2 errors, 13 warnings, 1615 lines checked

/home/lenb/Documents/wakeup.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


