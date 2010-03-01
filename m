Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0CASXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:23:38 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:33745 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0CASXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:23:36 -0500
Date: Mon, 01 Mar 2010 13:23:25 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Corentin Chary <corentin.chary@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Anisse Astier <anisse@astier.eu>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Harald Welte <laforge@gnumonks.org>,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Mattia Dongili <malattia@linux.it>, Peter Feuerer <peter@piie.net>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 01/14] MAINTAINERS: update drivers/platform/x86 information
In-reply-to: <20100301180211.GA19901@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1003011320540.4281@localhost.localdomain>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
 <1267197527-18062-2-git-send-email-mjg@redhat.com>
 <71cd59b01002261353w53fea6cax146acfd18e87636@mail.gmail.com>
 <alpine.LFD.2.00.1003011255030.4281@localhost.localdomain>
 <20100301180211.GA19901@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



thanks,
Len Brown, Intel Open Source Technology Center

On Mon, 1 Mar 2010, Matthew Garrett wrote:

> On Mon, Mar 01, 2010 at 12:59:03PM -0500, Len Brown wrote:
> 
> > Matthew,
> > Unless you object, I'll send Corentin's asus-laptop cleanup
> > upstream with my treek.
> 
> I've just pulled this in (along with a couple of other minor fixes) - 
> I'm just waiting to make sure I get the right set of Thinkpad fixes 
> before sending another pull request.

excellent.

please pick up this one too, and I'll delete my asus branch.

thanks,
-Len


>From 6204ff7f967d68b6c3b830b6df2cf2a3081b77a8 Mon Sep 17 00:00:00 2001
From: Roel Kluin <roel.kluin@gmail.com>
Date: Tue, 2 Feb 2010 14:37:57 -0800
Subject: [PATCH] asus-acpi: remove duplicate comparison of asus_model strings
X-Patchwork-Hint: ignore

These tests already occur elsewhere

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/platform/x86/asus_acpi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index c1d2aee..1381430 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1225,9 +1225,8 @@ static int asus_model_match(char *model)
 	else if (strncmp(model, "M2N", 3) == 0 ||
 		 strncmp(model, "M3N", 3) == 0 ||
 		 strncmp(model, "M5N", 3) == 0 ||
-		 strncmp(model, "M6N", 3) == 0 ||
 		 strncmp(model, "S1N", 3) == 0 ||
-		 strncmp(model, "S5N", 3) == 0 || strncmp(model, "W1N", 3) == 0)
+		 strncmp(model, "S5N", 3) == 0)
 		return xxN;
 	else if (strncmp(model, "M1", 2) == 0)
 		return M1A;
-- 
1.7.0.87.g0901d

