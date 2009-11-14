Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbZKNEce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbZKNEce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 23:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbZKNEcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 23:32:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48544
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757424AbZKNEcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 23:32:32 -0500
Date: Fri, 13 Nov 2009 20:32:48 -0800 (PST)
Message-Id: <20091113.203248.84989794.davem@davemloft.net>
To: andrew.hendry@gmail.com
Cc: netdev@vger.kernel.org, linux-x25@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X25: Enable setting of cause and diagnostic fields
From: David Miller <davem@davemloft.net>
In-Reply-To: <d45a3acc0911111613v38fa9df4jed21876ce6309097@mail.gmail.com>
References: <d45a3acc0911111613v38fa9df4jed21876ce6309097@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: andrew hendry <andrew.hendry@gmail.com>
Date: Thu, 12 Nov 2009 11:13:27 +1100

> Adds SIOCX25SCAUSEDIAG, allowing X.25 programs to set the cause and
> diagnostic fields.
> Normally used to indicate status upon closing connections.
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

This change is incomplete.

You need to add handling to compat_x25_ioctl().
