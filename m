Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZAUWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZAUWqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZAUWqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:46:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbZAUWqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:46:04 -0500
Date: Wed, 21 Jan 2009 14:46:06 -0800 (PST)
Message-Id: <20090121.144606.230078300.davem@davemloft.net>
To: tklein@de.ibm.com
Cc: jeff@garzik.org, raisch@de.ibm.com, ossthema@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org, hering2@de.ibm.com
Subject: Re: [PATCH 2/3] ehea: Fix mem allocations which require page
 alignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <200901211549.21066.tklein@de.ibm.com>
References: <200901211549.21066.tklein@de.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Klein <tklein@de.ibm.com>
Date: Wed, 21 Jan 2009 15:49:20 +0100

> PAGE_SIZE allocations via slab are not guaranteed to be page-aligned. Fixed
> all memory allocations where page alignment is required by firmware.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>

Applied.
