Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbZESV0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbZESV0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZESV01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:26:27 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:57202 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZESV00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:26:26 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on suspend
Date: Tue, 19 May 2009 23:26:46 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4A11C126.1000704@dell.com> <200905192158.12784.oliver@neukum.org> <4A131858.3080805@dell.com>
In-Reply-To: <4A131858.3080805@dell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905192326.46274.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Mai 2009 22:36:40 schrieb Mario Limonciello:
> [  112.471157] pm_op(): usb_dev_resume+0x0/0x10 returns -19
> [  112.471160] PM: Device 3-4.3 failed to resume: error -19
> [  112.471373] PM: resume devices took 3.256 seconds
> [  112.471980] PM: Finishing wakeup.
> [  112.471982] Restarting tasks ... <6>usb 3-4.3: USB disconnect, address 5

This error shouldn't happen. But you do get a disconnection. Please
recheck you see no udev event and please post "lsusb -v" before and
after suspension.

	Regards
		Oliver

