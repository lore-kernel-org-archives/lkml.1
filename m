Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYCLXDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYCLXDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYCLXCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:02:47 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:31774 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754047AbYCLXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:02:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Oget9RHAL6MRudOmQLUWTU7Be+H00nug++O7ZXXi1+biP4RmJFXZ1t5LHQU9UtXGjrc79b2tw03uSS02R/FHRHn/Rh0ivEVulcQSoWQsjr0Ha7hvoESt58tduIxTQhwyen8Nj9zMN/waIfQDLKLcV9lcU/M2zcAJP61h1OuOJ8s=  ;
X-YMail-OSG: 7Us5xiAVM1lb4J9i4RjtuUmloZW_oU81tBw4BtW56cCQ53fumSKUn6BDnlGFmtTTyd8Kx8BuQA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.25-rc5] kerneldoc for <linux/clk.h>
Date: Wed, 12 Mar 2008 14:58:37 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>
References: <200803101902.54407.david-b@pacbell.net>
In-Reply-To: <200803101902.54407.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121558.37960.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proof-reading doesn't always cut it ... an editor could help!

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Just editorial fixes to the $SUBJECT patch.

 Documentation/DocBook/kernel-api.tmpl |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- g26.orig/Documentation/DocBook/kernel-api.tmpl	2008-03-12 00:43:43.000000000 -0700
+++ g26/Documentation/DocBook/kernel-api.tmpl	2008-03-12 15:41:48.000000000 -0700
@@ -671,16 +671,15 @@ X!Idrivers/video/console/fonts.c
 	Power management is supported by explicit software clock gating:
 	unused clocks are disabled, so the system doesn't waste power
 	changing the state of transistors that aren't in active use.
-	On some systems this may be backed by hardware clock gating.
-	Circuits will still have leakage current to be managed, which
-	costs more with finer cicuit geometries, but for CMOS circuits
-	power is mostly spent by clocked state changes.
+	On some systems this may be backed by hardware clock gating,
+	where clocks are gated without being disabled in software.
 	Sections of chips that are powered but not clocked may be able
 	to retain their last state.
 	This low power state is often called a <emphasis>retention
-	mode</emphasis>, in contrast to <emphasis>off</emphasis> where
-	power is cut and no state is retained but where leakage currents
-	may have a significant impact on battery life.
+	mode</emphasis>.
+	This mode still incurs leakage currents, especially with finer
+	circuit geometries, but for CMOS circuits power is mostly used
+	by clocked state changes.
      </para>
 
      <para>
