Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbYF3JBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbYF3JBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYF3JAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:00:53 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41173 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYF3JAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:00:52 -0400
Subject: Re: [PATCH 3/3] mmc: fix sdio_io sparse errors
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <1214812224-32267-3-git-send-email-tomas.winkler@intel.com>
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
	 <1214812224-32267-2-git-send-email-tomas.winkler@intel.com>
	 <1214812224-32267-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 11:01:02 +0200
Message-Id: <1214816462.11537.26.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

> This patch fixes sdio_io sparse errors.
> This fix changes signature of API functions,
> changing
> unsigned char -> u8
> unsigned short -> u16
> unsigned long -> u32 - this was probably a bug in 64 bit platforms

why are we not using the new get_unaligned_le* and put_unaligned_le*
functions for the tmpbuf access?

Regards

Marcel


