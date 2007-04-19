Return-Path: <linux-kernel-owner+w=401wt.eu-S1031161AbXDSHpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031161AbXDSHpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031193AbXDSHpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:45:18 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:38521 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031161AbXDSHpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=lcjXQm/pnL6UzNUPutYHLoGDEbmAJEi4VY/EGoe49QTbMkswQQ6f9NeKAet1TannteWqOoiqT1WzT8Tgo49EkZJj/0rt9z+yOe5bDq0LF0kyKG9Kxz8FOWUHdwKzrI1yX647XFJiHPYwSwqm6MZljaHj+QVfpjejuivFqhyGFzI=
Message-ID: <33e9dd1c0704190045v62cd1b4fm8ded434086108dd5@mail.gmail.com>
Date: Thu, 19 Apr 2007 17:45:16 +1000
From: "Zik Saleeba" <zik@zikzak.net>
To: linux-kernel@vger.kernel.org
Subject: How to structure an SPI UART driver?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 86ff2abe6dcdbc9d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for a little advice on writing a driver for the Phillips
sc16is752 SPI UART chip. I've written drivers before but I'm having a
problem with this one. Since this driver is both an SPI driver and a
UART driver I'm unclear on whether it should register with
spi_register_driver() or uart_register_driver(), or both, or do
something completely different. I'm not clear on how to play nicely
with both subsystems.

Any hints?

Cheers,
Zik
