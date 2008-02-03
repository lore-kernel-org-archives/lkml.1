Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbYBCTBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbYBCTBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 14:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYBCTBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 14:01:42 -0500
Received: from mrqout1-sorbs.tiscali.it ([195.130.225.22]:58728 "EHLO
	mrqout1.tiscali.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751205AbYBCTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 14:01:41 -0500
X-Greylist: delayed 1661 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2008 14:01:41 EST
Message-ID: <19861822.1202063637753.JavaMail.root@ps23>
Date: Sun, 3 Feb 2008 19:33:57 +0100 (CET)
From: "f.cecco77@tiscali.it" <f.cecco77@tiscali.it>
Reply-To: "f.cecco77@tiscali.it" <f.cecco77@tiscali.it>
To: linux-kernel@vger.kernel.org
Subject: hpet on nforce4/MCP51 in asus a6t
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
xOriginalSenderIP: 213.230.130.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have  a asus a6t with nforce4/MCP51 chipset. I pass to kernel 2.6.24 
32 bit the options acpi_use_timer_override and hpet=force, in this way 
and the timer IRQ ends up routed as  IO-APIC-edge instead of XT-PIC. 
With acpi_use_timer_override I just get:

TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1

and it works through the IO-APIC. 

Instead the hpet is disabled and I  just get :

Time: acpi_pm clocksource has been installed.
Clocksource tsc unstable (delta = -85010975 ns)

Is possible to have hpet working also with if the BIOS doesn't support 
it ?

I wish to be personally CC'ed the answers/comments posted to the list 
in response to my posting.

Cecco






____________________________________________________
Tiscali.Fax: ricevi gratis sulla tua email e invii 
a 12 cent per pagina senza scatto alla risposta
http://vas.tiscali.it/fax//

