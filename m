Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYJKME5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYJKME5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 08:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYJKMEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 08:04:49 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:31694 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYJKMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 08:04:48 -0400
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :PmMGcFK8W/5pU+Ks2M0NQC5NPKGZSjWcOhfQxYOYw6MBSrjHNDROaqGynQ==
Message-ID: <48F09658.8060502@au-79.de>
Date: Sat, 11 Oct 2008 14:04:40 +0200
From: Robert Goldner <robert@au-79.de>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Patch needed for ASUS EEEPC 701 2.6.27 (perhaps a regession)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am a happy user of an asus eeepc 701 with an self-made kernel 2.6.27. 
Its working quite good, but there is one patch needed to avoid problems 
related to ACPI and Hotkeys.
After using a few hotkeys there comes a message in syslog like:
ACPI: EC: GPE storm detected, disabling EC GPE
and no hotkey event is recognized any more. This is quite bad on a nettop.

The needed patch and the bug description is available at:
http://bugzilla.kernel.org/show_bug.cgi?id=10919
The patch is called 'patch vs 2.6.27-rc7'

The patch fits also to 2.6.27 without any problems and works very fine. 
Thanks to everyone who was involved.

I would suggest to include this patch in the mainline kernel very soon 
(e.g. 2.6.28 or if possible in 2.6.27.1).

Best regards

Robert

P.S. To avoid me to adorn myself with borrowed plumes: I did not wrote 
these patch, I don't understand the patch, I only use the patch.
