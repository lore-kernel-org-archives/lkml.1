Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZAKOwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZAKOwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZAKOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:52:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:45205 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752239AbZAKOwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:52:09 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/LVJdH7azLIL/6R9jZXKcn7BOSaBZkaWL7Fn6gq0
	94QJKnhGoWGiUm
Message-ID: <496A0793.3070309@fisher-privat.net>
Date: Sun, 11 Jan 2009 15:52:03 +0100
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [Bug #12420] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <oWTznAnH9BI.A.PPH.GHfaJB@chimera>
In-Reply-To: <oWTznAnH9BI.A.PPH.GHfaJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12420
> Subject		: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
> Submitter	: Christian Borntraeger <borntraeger@de.ibm.com>
> Date		: 2009-01-09 12:34 (3 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=871af1210f13966ab911ed2166e4ab2ce775b99d
> References	: http://marc.info/?l=linux-kernel&m=123150457832109&w=4
> 

I just realised, this warning message normally should inculde DMI System
Product Name ( Hardware Name ), but my board do not support this filed (
it geve only "System Product Name" ) and use only DMI Board Product Name
instead. It should be "5LD2-VM".

------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x480/0x6c2()
Hardware name: System Product Name
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Should be like:
Hradware name: P5LD2-VM

See my dmidecoe:

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: stem manufacturer
        Product Name: System Product Name
        Version: System Version
        Serial Number: System Serial Number
        UUID: [------------cuted out--------------]
        Wake-up Type: PCI PME#
        SKU Number: <BAD INDEX>
        Family: <BAD INDEX>

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
        Manufacturer: ASUSTeK Computer INC.
        Product Name: P5LD2-VM
        Version: Rev 1.xx
        Serial Number: MB-1234567890
        Asset Tag: To Be Filled By O.E.M.
        Features:
                Board is a hosting board
                Board is replaceable
        Location In Chassis: To Be Filled By O.E.M.
        Chassis Handle: 0x0003
        Type: Motherboard
        Contained Object Handles: 0
