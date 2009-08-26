Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbZHZBR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbZHZBR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932650AbZHZBR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:17:29 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:36526 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbZHZBR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=o5DaTDMEWZLjWGDnQHhTMe1X7VgRIy6YRaEZX4wE3cJlPN7DfjLVNmqKPwgqk5WvGE
         0JNxTeSb5NHLsh8z6Uv+H9s5p2e/ODFzDYg0n0m064Qwfnuy8MT5brkXuW9Utq2LNR54
         Kzip9HT1VAuQFczjSnDlqIvzzlekXem7iSm9U=
MIME-Version: 1.0
Date: Tue, 25 Aug 2009 18:17:28 -0700
Message-ID: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com>
Subject: expresscard hotplug not working
From: Mike Mohr <akihana@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think I'm having a similar problem to the fellow listed here:

http://kerneltrap.org/mailarchive/linux-kernel/2007/10/16/344543

The only difference is that no card will work at all unless it is
inserted before system power is turned on.  If the card is removed
while the system is running it stops working and will never return to
life unless the system is rebooted with the card in the slot.

My kernel is configured exactly as this page describes:

http://www.gentoo-wiki.info/ExpressCard

However, I do not receive anything in dmesg except the reports of the
driver being unloaded and/or loaded.  Attempts to insert the card
after the machine is up elicit no kernel messages.  I'm thinking there
may be a missing PCI ID somewhere in the pciehp/pci_hotplug driver(s),
but I could well be mistaken.

Can anyone offer me a suggestion or two?

Thanks,
Michael
