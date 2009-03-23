Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZCWIyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZCWIyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZCWIy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:54:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:28765 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbZCWIy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=LLuquMA27uXnUEtBJnlpsQp4kuhnpDLy4PpEliUmAGlUe55bVTAW5kqk1+4NQ6yXIH
         vp4GD5NXc2UUo03dq1Fn6ctBSJ2BN6JjAvXfxFTdxCQ/RdpliST72sHbd0IIzV4dgGYf
         GrUx8Qyi0NeWhIaPqucqHlpOdPsb2wnAMDbeo=
Date: Mon, 23 Mar 2009 01:54:25 -0700 (PDT)
From: justinmattock@gmail.com
To: linux-kernel@vger.kernel.org
Subject: ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts with ACPI
 region SMBI [0xefa0-0xefaf]
Message-ID: <alpine.LNX.2.00.0903230150110.2409@havk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Any suggestions on what this might be:
(dmesg):

[    6.940280] power_supply ADP1: 1 dynamic props
[    6.940283] power_supply ADP1: prop ONLINE=1
[    6.940340] input: Sleep Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input5
[    6.968564] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    6.977814] ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts 
with ACPI region SMBI [0xefa0-0xefaf]
[    6.987218] ACPI: Device needs an ACPI driver
[    7.000114] ath9k: 0.1
[    7.000163] ACPI: Sleep Button (CM) [SLPB]
[    7.018052] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17
[    7.027094] ath9k 0000:03:00.0: setting latency timer to 64

either i801_smbus(to me) is the issue, or it's something else.

any ideas?

-- Justin P. Mattock
