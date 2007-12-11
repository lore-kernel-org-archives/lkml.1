Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbXLKQd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbXLKQd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXLKQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:33:49 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:62725 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXLKQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:33:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18270.48009.256443.854729@stoffel.org>
Date: Tue, 11 Dec 2007 11:32:09 -0500
From: "John Stoffel" <john@stoffel.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Paul Rolland <rol@as2917.net>, David Newall <david@davidnewall.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
In-Reply-To: <475EACB8.7080608@keyaccess.nl>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
	<475CBDD7.5050602@keyaccess.nl>
	<m3bq8y23de.fsf@maximus.localdomain>
	<475DE37F.20706@davidnewall.com>
	<475DE6F4.80702@zytor.com>
	<475DEB23.1000304@davidnewall.com>
	<20071211084059.3d03e11d@tux.DEF.witbe.net>
	<475E5D4B.8020101@keyaccess.nl>
	<475E7DC2.4060509@davidnewall.com>
	<475E8D91.20201@keyaccess.nl>
	<20071211143224.15900995@tux.DEF.witbe.net>
	<475E9B9B.2050709@keyaccess.nl>
	<475EACB8.7080608@keyaccess.nl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's my results on a PIII Xeon, 550mhz, 440GX chipset, and an ISA
slot, which until recently was actually used with an 8 port serial
card:

jfsnew:~/src> sudo ./port80
out: 729
in : 348
jfsnew:~/src> sudo ./port80
out: 729
in : 354
jfsnew:~/src> sudo ./port80
out: 729
in : 350
jfsnew:~/src> sudo ./port80
out: 728
in : 346
jfsnew:~/src> sudo ./port80
out: 730
in : 340
