Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZDUHES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZDUHES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZDUHD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:03:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:32329 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZDUHD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AWfVqR3lOVwVFMfxULUu5v/833JuiDuPYXOkxEg6neoISX8RBQNgSzFq5VFq0mMDi2
         C2zWObEtutI85GpKAdOIItOdP+APxSRR16vvtC6JfEWqHS4jVR/9vSWqt6GCvN6RYHRo
         be7cxJpN+V9KjfKef3f+6ME1MrvThUxkEa1EI=
Message-ID: <49ED6FD7.3070307@panasas.com>
Date: Tue, 21 Apr 2009 10:03:51 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Is sata_nv compatible with async scsi scan?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Since 2.6.29 I'm having intermittent problems with booting kernels.
After supposedly waiting for scsi async scan to complete,
quite frequently I see errors from the init resume process
when it fails to find the swap partition and later the root
file system fails to load.

A workaround that I found to be helpful is booting the kernel
with scsi_mod.scan=sync so I suspect sata_nv has a problem
with asynchronous scanning.

The two machines this happens on have:
IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)

and

IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)

This one: IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
seems to be less prone to the problem, though I tend to reboot it
much less frequently, so it's possible I just happened to be lucky with it.

Benny
