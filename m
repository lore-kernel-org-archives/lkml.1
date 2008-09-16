Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYIPNJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYIPNJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYIPNJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:09:11 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:34287 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751203AbYIPNJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:09:10 -0400
X-YMail-OSG: 0ZF8R58VM1lfUVAXQ1d3HiyqCU5HH7cQNXDcwKoZAjNJl3pzcld1KZB4XwyVFPHf5A--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Tue, 16 Sep 2008 06:09:08 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: How to find out, what "pdflush" is working on
To: linux-kernel@vger.kernel.org
Cc: Peter zijlstra <a.p.zijlstra@chello.nl>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <849662.25086.qm@web32602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 I find the following comment in mm/pdflush.c

/*
 * The pdflush threads are worker threads for writing back dirty data.
 * Ideally, we'd like one thread per active disk spindle.  But the disk
 * topology is very hard to divine at this level.   Instead, we take
 * care in various places to prevent more than one pdflush thread from
 * performing writeback against a single filesystem.  pdflush threads
 * have the PF_FLUSHER flag set in current->flags to aid in this.
 */

 Is there a way to find out what a certain instance of "pdflush" is working on? Like which block-device or which fliesystem it is writing to? I am still (2.6.27) trying to track down why writing a single file can make linux very sluggish and unresponsive. If that happens I usually see all possible 8 "pdflush" threads being in "D"-state. According to above comment only one of them should be really busy.

Cheers
Martin
------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de

