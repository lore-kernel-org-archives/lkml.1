Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYJaRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYJaRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYJaRJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:09:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:11371 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYJaRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=V7WumxQofJkmiPC/Ers8QeVeYDsDRLU5hRsV0Um7ZWERbzFWflw2WYjvyqUOOAJKMq
         Nzu3R5V66cft51rAJ2k47tuszKe6T4MvcghHU0zpOeqyB7/UzmhyOK4mjayQl5ckHTSn
         BL4/IDtqT+itDaxSjN8j9/TSU05BtZlUaDb1g=
Message-ID: <490B3BB5.8060801@tuffmail.co.uk>
Date: Fri, 31 Oct 2008 17:09:09 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: eeepc-laptop rfkill, stupid question #4 and 5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did you miss a call to rfkill_force_state() on resume?

I can hibernate, then interrupt the boot with F2 to get into the BIOS,
change the "Enable WLAN" setting, and continue the resume.  When the
eeepc-laptop driver resumes, it restores the pre-hibernation value.

Actually, normal boot doesn't preserve the setting either.  Your commit
changes the behaviour from the rfkill state being persistent across
reboot / power off (as a bios setting), to being always enabled on
boot.  It seems like a bad idea to me.

Thanks
Alan
