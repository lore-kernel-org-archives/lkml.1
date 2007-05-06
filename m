Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXEFQtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXEFQtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 12:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXEFQtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 12:49:46 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:59968 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbXEFQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 12:49:45 -0400
Date: Sun, 6 May 2007 18:49:44 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21] kernel panic
Message-ID: <20070506164944.GA15682@vanheusden.com>
References: <20070506115651.GA13183@vanheusden.com> <Pine.LNX.4.64.0705061632500.16923@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0705061632500.16923@twin.jikos.cz>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Mon May  7 18:43:47 CEST 2007
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > A few moments ago a system of mine running 2.6.21 on a P4 with
> > hyperthreading, 2GB ram, IDE disk, crashed:
> > [10371.128320] BUG: unable to handle kernel paging request at virtual address 00100100
> > [10371.128419]  printing eip:
> [...]
> > [10371.131825] EIP is at hiddev_send_event+0xa1/0xd3
> 
> I will look into it. Are you able to reproduce the problem, or did it 
> happen just randomly? Is there any userspace driver using the hiddev 
> interface at the moment it crashes?
> There have been no changes in the hiddev code for a pretty long time.

It is the first time this happened altough with 2.6.21 I get relatively
frequent warnings of circular locks dependencies. This is the first time
it was followed by an oops.
Connected via hid are 2 temperature sensors and an UPS. Has been running
fine for ages.


Folkert van Heusden

-- 
MultiTail es una herramienta flexibele para consiguir archivos de log,
y para ejecutar ordenes. Filtrar, añadir colores, merger y vista de
las differencias.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
