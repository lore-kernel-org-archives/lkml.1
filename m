Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbYF1AY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbYF1AY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 20:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYF1AYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 20:24:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50209
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbYF1AYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 20:24:16 -0400
Date: Fri, 27 Jun 2008 17:24:16 -0700 (PDT)
Message-Id: <20080627.172416.106612371.davem@davemloft.net>
To: miquels@cistron.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp.c: calculate tcp_mem based on low memory instead
 of all memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080618153042.GA27663@xs4all.net>
References: <20080618153042.GA27663@xs4all.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miquel van Smoorenburg <miquels@cistron.nl>
Date: Wed, 18 Jun 2008 17:30:45 +0200

> [PATCH] tcp.c: calculate tcp_mem based on low memory instead of all memory
> 
> The tcp_mem array which contains limits on the total amount of
> memory used by TCP sockets is calculated based on nr_all_pages.
> On a 32 bits x86 system, we should base this on the number of
> lowmem pages.
> 
> Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

Patch applied, thanks Miquel.
