Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZGNSdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZGNSdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbZGNSdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:33:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47436
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755845AbZGNSdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:33:44 -0400
Date: Tue, 14 Jul 2009 11:33:48 -0700 (PDT)
Message-Id: <20090714.113348.155881037.davem@davemloft.net>
To: eeeesti@gmail.com
Cc: amluto@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Tell linkwatch about new interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <ce0170d90907141017h732c2cd7ja5990303093b6edd@mail.gmail.com>
References: <cb0375e10904010840n1543a890w9039465d0f80ffcc@mail.gmail.com>
	<20090404.170539.148727646.davem@davemloft.net>
	<ce0170d90907141017h732c2cd7ja5990303093b6edd@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergio Luis <eeeesti@gmail.com>
Date: Tue, 14 Jul 2009 14:17:21 -0300

> is this patch incorrect, though? with the linkwatch_fire_event() call,
> the rfc2863 operstate will be set for everyone at device register
> time.

The issue is dumb drivers that do not manage their link state
at all.  We want them to always have their links up, from the
moment they are registered.

This is especially important for virtual devices.
