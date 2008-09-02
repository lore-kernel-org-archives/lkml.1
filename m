Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYIBXlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYIBXlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYIBXli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:41:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38849
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbYIBXlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:41:36 -0400
Date: Tue, 02 Sep 2008 16:41:30 -0700 (PDT)
Message-Id: <20080902.164130.156055373.davem@davemloft.net>
To: rick.jones2@hp.com
Cc: alan@lxorguk.ukuu.org.uk, stephen.hemminger@vyatta.com,
       shemminger@vyatta.com, dusanc@gmail.com, romieu@fr.zoreil.com,
       hancockr@shaw.ca, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       bridge@lists.linux-foundation.org
Subject: Re: [RFC] bridge: STP timer management range checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <48BD6C8E.5060704@hp.com>
References: <48BB295A.6050200@vyatta.com>
	<20080901093827.24eec86f@lxorguk.ukuu.org.uk>
	<48BD6C8E.5060704@hp.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rick Jones <rick.jones2@hp.com>
Date: Tue, 02 Sep 2008 09:40:46 -0700

> Can one change the TCP maximum RTO to be smaller than specified in the specs?

We always min-clamp the RTO at RTO calculation time in order to be
compatible with BSD's coarse grained times.
