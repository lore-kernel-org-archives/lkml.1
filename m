Return-Path: <linux-kernel-owner+w=401wt.eu-S1764089AbXJTNvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764089AbXJTNvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXJTNvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:51:35 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:58492 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXJTNve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:51:34 -0400
Subject: Re: [Bluez-devel] [PATCH] bluetooth: Eliminate checks for
	impossible conditions in	irq handler
From: Marcel Holtmann <marcel@holtmann.org>
To: BlueZ development <bluez-devel@lists.sourceforge.net>
Cc: maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071019073132.GA5678@havoc.gtf.org>
References: <20071019073132.GA5678@havoc.gtf.org>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 15:52:15 +0200
Message-Id: <1192888335.6184.115.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

>     [BLUETOOTH] Eliminate checks for impossible conditions in irq handler
>     
>     Our info structure and info->hdev is always passed to the irq handler,
>     so we don't have to worry about these checks in every interrupt.
>     
>     Leave a BUG_ON() just to help unwary programmers, but these could
>     probably be removed as well.

applied to my tree. Thanks.

Regards

Marcel


