Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbYDTBkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbYDTBkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 21:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYDTBkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 21:40:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52363
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbYDTBkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 21:40:08 -0400
Date: Sat, 19 Apr 2008 18:40:10 -0700 (PDT)
Message-Id: <20080419.184010.113401925.davem@davemloft.net>
To: pidoux@ccr.jussieu.fr
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       linux-hams@vger.kernel.org
Subject: Re: [PATCH] rose_node_list_lock was not released before returning
 to user space
From: David Miller <davem@davemloft.net>
In-Reply-To: <480A6034.1080806@ccr.jussieu.fr>
References: <480A6034.1080806@ccr.jussieu.fr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernard Pidoux <pidoux@ccr.jussieu.fr>
Date: Sat, 19 Apr 2008 23:12:20 +0200

> Subject: [PATCH] rose_node_list_lock was not released before returning to user space

BTW, I had to fix the commit message because it's not the
rose_node_list_lock that isn't being released, it's the socket lock.
