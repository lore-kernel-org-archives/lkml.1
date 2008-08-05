Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbYHEJhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbYHEJhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYHEJhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:37:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34846
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbYHEJhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:37:34 -0400
Date: Tue, 05 Aug 2008 02:37:34 -0700 (PDT)
Message-Id: <20080805.023734.156470524.davem@davemloft.net>
To: rjw@sisk.pl
Cc: jbarnes@virtuousgeek.org, arekm@maven.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: BUG: scheduling while atomic: ip/23212/0x00000102
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808051117.28824.rjw@sisk.pl>
References: <200808050153.23537.rjw@sisk.pl>
	<200808041705.45317.jbarnes@virtuousgeek.org>
	<200808051117.28824.rjw@sisk.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, 5 Aug 2008 11:17:28 +0200

> Okay, but tg3 evidently wants to set the power state to D0 under a spinlock
> (without the delay required by the PCI PM spec, but well).

Please read the rest of your inbox, we found a way to fix
tg3 to not need to call this under a lock.
