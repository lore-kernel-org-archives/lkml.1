Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbXGZQ2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbXGZQ2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760998AbXGZQ2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:28:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51442 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759715AbXGZQ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:28:39 -0400
Date: Thu, 26 Jul 2007 18:28:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kyle Rose <krose@akamai.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
In-Reply-To: <46A8BAD4.8020004@akamai.com>
Message-ID: <Pine.LNX.4.64.0707261826180.12711@fbirervta.pbzchgretzou.qr>
References: <46A8BAD4.8020004@akamai.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26 2007 11:16, Kyle Rose wrote:
>
>   1.
>
>      Make sure you have the headers for your kernel properly installed
>      and linked to /usr/src/linux-$KVER.

Why is this a requirement? Makefile not properly done?

>   4.
>
>      Look in /tmp for a directory called Sk98something. Go to

Why /tmp? If untarred (with default options) in ~, it's in ~/tmp.

>   5.
>
>      Change into /tmp/Sk98something/all and execute:
>
>          sudo -H make -C /usr/src/linux-$KVER M=`pwd` modules
>          sudo -H make -C /usr/src/linux-$KVER M=`pwd` modules_install

This breaks with O= builds. See (1).


Sorry for the nitpick, it can be done easier :)




	Jan
-- 
