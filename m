Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0BBX1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 18:27:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50411 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754373Ab0BBX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 18:27:12 -0500
Date: Tue, 2 Feb 2010 23:27:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/68] ide2libata
Message-ID: <20100202232748.61e29030@lxorguk.ukuu.org.uk>
In-Reply-To: <20100202.151900.211475917.davem@davemloft.net>
References: <20100201125845.3f468363@lxorguk.ukuu.org.uk>
	<20100201.051432.226757615.davem@davemloft.net>
	<4B68B0CF.1040907@garzik.org>
	<20100202.151900.211475917.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the drivers get truly shared between IDE and ATA, that
> presumption is entirely removed, the ATA testers will
> be hitting the same driver code that whatever remaining
> IDE users will be.

Assuming the data structures matching does that is a bit like assuming
you can test one TCP stack using another one because they use the same
packet format.

