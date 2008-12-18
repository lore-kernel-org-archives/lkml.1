Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752169AbYLRQYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbYLRQYY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYLRQYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:24:12 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54844 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751358AbYLRQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:24:08 -0500
Date: Thu, 18 Dec 2008 17:24:06 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andy Whitcroft <apw@shadowen.org>, Joel Schopp <jschopp@austin.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: checkpatch and pr_fmt()?
Message-ID: <Pine.LNX.4.64.0812181718250.1445@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the recently introduced pr_fmt() infrastructure (commit
d091c2f58ba32029495a933b721e8e02fbd12caa, "Add 'pr_fmt()' format modifier to
pr_xyz macros."), checkpatch spits out the following annoying error:

| ERROR: Macros with complex values should be enclosed in parenthesis
| +#define pr_fmt(fmt)    "%s: " fmt, __func__

Unfortunately, adding parentheses is not a solution, as it creates illegal C
code.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
