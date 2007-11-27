Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXK0QEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXK0QEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbXK0QEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:04:41 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4269 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbXK0QEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:04:40 -0500
X-Server-Uuid: 20144BB6-FB76-4F11-80B6-E6B2900CA0D7
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: Re: 2.6.23-mm1 tg3 wake-on-lan oddity...
Date: Tue, 27 Nov 2007 08:04:28 -0800
Message-ID: <1551EAE59135BE47B544934E30FC4FC002AABB51@nt-irva-0751.brcm.ad.broadcom.com>
In-Reply-To: <24400.1196156118@turing-police.cc.vt.edu>
Thread-Topic: 2.6.23-mm1 tg3 wake-on-lan oddity...
Thread-Index: Acgw2N5hbaHfJkILTGWtOxg49szljAANehNw
From: "Michael Chan" <mchan@broadcom.com>
To: Valdis.Kletnieks@vt.edu
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-WSS-ID: 6B529F850SG11631844-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> (a) the Dell factory default is WOL disabled and (b) 
> if it wasn't
> the default, I'd have *set* it to disabled, and (c) I even 
> went back and
> rebooted and checked the BIOS setting - disabled. Nonetheless:
> 
> # ethtool eth0 | grep Wake
>         Supports Wake-on: g
>         Wake-on: g
> 
> Is this expected behavior?
> 

The new tg3 is supposed to follow the WoL setting in the
NVRAM, so this is not expected.  We'll have to look into
this.

