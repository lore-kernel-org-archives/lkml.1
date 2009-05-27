Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZE0Ds1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZE0Ds1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbZE0DsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:48:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48624
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757068AbZE0DsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:48:16 -0400
Date: Tue, 26 May 2009 20:48:15 -0700 (PDT)
Message-Id: <20090526.204815.185454308.davem@davemloft.net>
To: Xiaotian.Feng@windriver.com
Cc: galak@kernel.crashing.org, netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] gianfar: fix babbling rx error event bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243389156-1668-1-git-send-email-Xiaotian.Feng@windriver.com>
References: <1243389156-1668-1-git-send-email-Xiaotian.Feng@windriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <Xiaotian.Feng@windriver.com>
Date: Wed, 27 May 2009 09:52:36 +0800

> Gianfar interrupt handler uses IEVENT_ERR_MASK to check and handle errors.
> Babbling RX error (IEVENT_BABR) should be included in IEVENT_ERROR_MASK.
> Otherwise if BABR is raised, it never gets handled nor cleared, and an
> interrupt storm results. This has been observed to happen on sending a
> burst of ethernet frames to a gianfar based board.
> 
> Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>

Patch applied, thanks.
