Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbZFBSCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbZFBSCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757508AbZFBSCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:02:37 -0400
Received: from mail-qy0-f104.google.com ([209.85.221.104]:52911 "EHLO
	mail-qy0-f104.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbZFBSCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=tGHF/pJF2ZMKKVIILfSvlqUQRkZE/gKuv3+2f9owMToQ+TByFyHl4OB3atXDhXMzbl
         0KWE3a3NHRvBskaPxUVKdKmRlTQG7+szmtpLbxNKs9Rqb+CcyL8+CpJ8n0Ax6RPH2kad
         v4XQscOpxyC6EtpEQXjo9T43bGFh5/lQJaStY=
MIME-Version: 1.0
Date: Tue, 2 Jun 2009 11:02:37 -0700
Message-ID: <dd18b0c30906021102h43b8ecc4u9e67687de129bca1@mail.gmail.com>
Subject: ACPI Exception (evregion-0422): AE_ERROR, Returned by Handler for 
	[PCI_Config] [20090320]
From: Justin Mattock <justinmattock@gmail.com>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted this error a few weeks ago, but had no response.
So after a few weeks of looking at this, I wanted to find out if
this is safe to see this, or should I be concerned:

[    5.868418] ACPI: Power Button [PWRB]
[    5.868547] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
[    5.868621] ACPI: Sleep Button [SLPB]
[    6.093547] ACPI Exception (evregion-0422): AE_ERROR, Returned by
Handler for [PCI_Config] [20090320]
[    6.093555] ACPI Error (psparse-0537): Method parse/execution
failed [\_SB_.PCI0.RP01.GFX0._PS0] (Node f703dcc0), AE_ERROR
[    6.093614] ACPI: Transitioning device [GFX0] to D0

I did do a dsdt dump, and looked for any errors
but none had shown up.
kernels that I have seen this are 2.6.29 -
2.6.30-rc5

-- 
Justin P. Mattock
