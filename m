Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZIEVof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZIEVof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZIEVof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:44:35 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:58933 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZIEVoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:44:34 -0400
Date: Sat, 05 Sep 2009 23:44:35 +0200
Message-Id: <899288751@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: block_dump - full path ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19t0byT1XIZY4KwdpdxE/mMTYthrV2zzWy0x/gIn87uOiqqh
 +TDZmaBltGKLLn8CpTyZzpruMzV4IIZwjUNATKmayXeDFguflA=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

i came across the nice debugging feature sysctl vm.block_dump=1 which leaves information on read/write in dmesg for every process.

Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542512 on sda2
Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542520 on sda2
Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542528 on sda2
Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144498288 on sda2
Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144916496 on sda2
Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144917376 on sda2
Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144704600 on sda2

is it possible to log the full path of the process ?

i assume it is a missing feature, correct ?

what about adding full path support, to be enabled with "sysctl vm.block_dump=2" ?

regards
roland

______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

