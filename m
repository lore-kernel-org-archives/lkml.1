Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbXFJUh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbXFJUh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXFJUhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:37:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:20690 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXFJUhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:37:16 -0400
Date: Sun, 10 Jun 2007 22:37:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jiri Kosina <jikos@jikos.cz>
cc: Folkert van Heusden <folkert@vanheusden.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrea Righi <righiandr@users.sourceforge.net>, Andi Kleen <ak@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
In-Reply-To: <Pine.LNX.4.64.0706102200400.23280@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0706102236380.3561@fbirervta.pbzchgretzou.qr>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr>
 <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de>
 <46517817.1080208@users.sourceforge.net> <20070521110406.GA14802@vanheusden.com>
 <Pine.LNX.4.61.0705211420100.4452@yvahk01.tjqt.qr> <20070521124734.GB14802@vanheusden.com>
 <a781481a0705231100q333a589at6c025eb1292019cd@mail.gmail.com>
 <20070523184535.GE21655@vanheusden.com> <20070610195333.GB15616@vanheusden.com>
 <Pine.LNX.4.64.0706102200400.23280@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 10 2007 22:06, Jiri Kosina wrote:
>On Sun, 10 Jun 2007, Folkert van Heusden wrote:
>
>> Signed-of by: Folkert van Heusden <folkert@vanheusden.com
>
>This looks broken BTW.
>
>> +			printk(KERN_INFO "Sig %d sent to %d owned by %d.%d (%s), sent by pid %d, uid %d\n",
>> +				sig, t->pid, t->uid, t->gid, t->comm,
>> +				info -> _sifields._kill._pid,
>> +				info -> _sifields._kill._uid);
>
>Am I the only one whose eyes are hurt by these spaces?

They were discussed before already. And they were fixed up (t->uid...).
And now new ones got added. Ergh.



	Jan
-- 
