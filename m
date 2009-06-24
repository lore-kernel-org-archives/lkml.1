Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZFXGwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZFXGwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZFXGw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:52:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54489
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbZFXGw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:52:28 -0400
Date: Tue, 23 Jun 2009 23:52:32 -0700 (PDT)
Message-Id: <20090623.235232.56133010.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] ide: improve handling of Power Management requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906232335.57161.bzolnier@gmail.com>
References: <200906232335.57161.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 23 Jun 2009 23:35:56 +0200

> Make hwif->rq point to PM request during PM sequence and do not allow
> any other types of requests to slip in (the old comment was never correct
> as there should be no such requests generated during PM sequence).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> This was tested in the past (with an additional testing from Borislav)
> however there were block layer changes in the meantime so you may want
> to give it some more testing time just to be sure.

This patch looks great, applied!

Thanks.
