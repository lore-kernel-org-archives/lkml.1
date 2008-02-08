Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbYBHTWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbYBHTWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYBHTWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:22:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:29480 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYBHTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=x8qrML19UZaL6sUa8FnqCCk/AKB1LYx9haMlAog/bpoHfES1td2rgX3RDlL9UgA1lo4pyikM3Q7smEO1s47QmcRzsO+az8QZJIUeL6I0bOsmOkP1C6RwUQesaIkOFcx55RkeWqIs3hdbc5njE0tC0chLkAQaN5wMPPVqfBX5fEM=
Message-ID: <6d4bc9fc0802081122g5b9a9ee7lc85d6f18e0dee74@mail.gmail.com>
Date: Fri, 8 Feb 2008 20:22:25 +0100
From: "Maarten Maathuis" <madman2003@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [x86_64] Cannot get the NMI watchdog to work
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me when replying.

Kernel is a 2.6.24-rt1.

Summary:
- 0 NMI interrupts occur by default (this remains true for any
situation encountered).
- nmi_watchdog=1 disables lapic for some reason.
- I have no hpet it seems, hpet=force doesn't do any good (the oposite
actually).
- I never get any reference of hpet in my dmesg.
- oprofile module is not loaded.
- My interrupts seem to have IO-APIC-* mode.
- My chipset is a nvidia CK804.

Can anyone shed some light on what is needed to get a working NMI watchdog?

Sincerely,

Maarten Maathuis.
