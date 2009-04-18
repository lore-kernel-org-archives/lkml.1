Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZDRIVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZDRIVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZDRIU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:20:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:34544 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZDRIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=VVOWF1a5cBPjBMV2PrU2TJPJnYawqJqRzuPr7GyeMDj2dA8x7PDAAMYUydWuWBVnKy
         cVXb2H7TuaK3FX32XajWco/eS2RJuCGgFhF/leCiXyn5JhLfQEJNw0418q868Is3puSB
         qu9BH8QR80U7QeFgl5OuAvexu/ViTpmoChFN4=
Subject: ACPI Exception (evregion-0422): AE_ERROR
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 18 Apr 2009 01:21:10 -0700
Message-Id: <1240042870.12779.5.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this in dmesg:

[   10.026103] hub 1-1:1.0: 3 ports detected
[   10.103940] nvidia: module license 'NVIDIA' taints kernel.
[   10.192783] usb 1-4: new high speed USB device using ehci_hcd and
address 3
[   10.375881] usb 1-4: configuration #1 chosen from 1 choice
[   10.381849] ACPI Exception (evregion-0422): AE_ERROR, Returned by
Handler for [PCI_Config] [20081204]
[   10.381864] ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.RP01.GFX0._PS0] (Node f703ecc0), AE_ERROR
[   10.381974] ACPI: Transitioning device [GFX0] to D0
[   10.381987] nvidia 0000:02:00.0: PCI INT A -> Link[Z003] -> GSI 23
(level, low) -> IRQ 23
[   10.381994] nvidia 0000:02:00.0: setting latency timer to 64


I do have a proprietary module(cant help that),
but doesn't make a difference.(still shows up irregardless);

should I be concerned with this from ACPI?

regards;

Justin P. Mattock

