Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYKKUC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYKKUC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYKKUCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:02:50 -0500
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4988 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYKKUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:02:49 -0500
Date: Tue, 11 Nov 2008 21:02:47 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.27] allows to rmmod 'ide_pci_generic' with mounted filesystems
Message-ID: <20081111200247.GQ10723@vanheusden.com>
References: <20081104172513.GH23232@vanheusden.com> <20081104172727.GJ23232@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104172727.GJ23232@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue Nov 11 11:09:27 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running my http://vanheusden.com/pyk/ script (which randomly
inserts and removes modules), the module 'ide_pci_generic' got unloaded
while filesystems were mounted that used that module. Of course the
system crashed but I think it should not be possible to unload
modules when resources it serves are still in use.


Folkert van Heusden

-- 
MultiTail cok yonlu kullanimli bir program, loglari okumak, verilen
kommandolari yerine getirebilen. Filter, renk verme, merge, 'diff-
view', vs.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
