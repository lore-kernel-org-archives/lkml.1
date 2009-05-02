Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbZEBUxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbZEBUxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759545AbZEBUw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:52:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55492
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758604AbZEBUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:52:54 -0400
Date: Sat, 02 May 2009 13:52:49 -0700 (PDT)
Message-Id: <20090502.135249.22146598.davem@davemloft.net>
To: jeff@garzik.org
Cc: lkundrak@v3.sk, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] Do not register ne2k-pci device until initialized
From: David Miller <davem@davemloft.net>
In-Reply-To: <49FC7D5E.6050203@garzik.org>
References: <1241281735.2641.7.camel@localhost.localdomain>
	<49FC7D5E.6050203@garzik.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Sat, 02 May 2009 13:05:34 -0400

> Lubomir Rintel wrote:
>> Doing it in reverse order causes uevent to be sent before
>> we have a MAC address, which confuses udev.
>> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> 
> Acked-by: Jeff Garzik <jgarzik@redhat.com>
> 
> Good spotting, that fixes a clear startup race

Applied, thanks.
