Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZJHJye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZJHJye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbZJHJyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:54:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56294 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756281AbZJHJyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:54:32 -0400
Date: Thu, 8 Oct 2009 10:55:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: linux-ide@vger.kernel.org,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>,
       Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH v2] ata: New PATA driver for Altera CompactFlash.
Message-ID: <20091008105503.6ce414f5@lxorguk.ukuu.org.uk>
In-Reply-To: <1254967110-3495-1-git-send-email-thomas@wytron.com.tw>
References: <1254967110-3495-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Oct 2009 09:58:30 +0800
Thomas Chou <thomas@wytron.com.tw> wrote:

> This patch adds a new PATA driver to support the Altera SOPC Builder
> CompactFlash component as a PATA device with support for insertion
> and removal of CF cards.  It uses the platform driver model.

Can you explain why you remove the interface rather than the device on
the interface when you detect a card removal ?

