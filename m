Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXJ3VlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXJ3VlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbXJ3VlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:41:07 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:57714 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXJ3VlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:41:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: 
Date: Tue, 30 Oct 2007 14:41:00 -0700
Message-ID: <598D5675D34BE349929AF5EDE9B03E27016E6182@az33exm24.fsl.freescale.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Index: AcgbPZBGQ7DIsKu+Rs652tKKxDZxYQ==
From: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
To: <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,


This commit
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
tdiff;h=502ef38da15d817f8e67acefc12dc2212f7f8aa1 makes make
headers_check fail like this.

  CHECK   include/linux/tipc_config.h
/home/emmedve1/Projects/Linux/swang/linux/usr/include/linux/tipc_config.
h requires linux/string.h, which does not exist in exported headers

I'm not sure whether the right solution is to include string.h to
include/linux/Kbuild (maybe not) or just remove linux/string.h from
tipc_config.h (perhaps). What do you suggest?


Cheers,
Emil.
