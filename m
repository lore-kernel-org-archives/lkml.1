Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZJTCgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZJTCgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 22:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZJTCgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 22:36:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51873
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756744AbZJTCgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 22:36:49 -0400
Date: Mon, 19 Oct 2009 19:37:11 -0700 (PDT)
Message-Id: <20091019.193711.147629067.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, alan@lxorguk.ukuu.org.uk, oliver@hartkopp.net,
       netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bluetooth: scheduling while atomic bug fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091019062441.GA4102@darkstar.vlan7>
References: <20091019062441.GA4102@darkstar.vlan7>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Mon, 19 Oct 2009 14:24:41 +0800

> Due to driver core changes dev_set_drvdata will call kzalloc which should be
> in might_sleep context, but hci_conn_add will be called in atomic context
> 
> Like dev_set_name move dev_set_drvdata to work queue function.
> 
> oops as following:
 ...
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Applied.
