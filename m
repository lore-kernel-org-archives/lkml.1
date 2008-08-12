Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbYHLBJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbYHLBJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYHLBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:09:18 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33814 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYHLBJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:09:06 -0400
Subject: Re: [patch 2/2] fastboot: use a DMI match table to set defaults
	for port-disable
From: Marcel Holtmann <marcel@holtmann.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20080811153730.74599410@infradead.org>
References: <20080811153542.61095e5c@infradead.org>
	 <20080811153730.74599410@infradead.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 03:09:11 +0200
Message-Id: <1218503351.25524.28.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

> Subject: [PATCH] libata: use a DMI match table to set defaults for port-disable
> 
> As suggested by Jeff:
> This patch adds a DMI table that is used for setting defaults for
> the new dont-probe-port parameter boot time optimization feature.
> 
> Initially, the table only contains the Asus EeePC 901 as this is the
> device I have for testing.

last time I had mine open, I saw that the other ATA connectors are in
theory usable. You have to do some heavy modifications, but some people
do modifications to this kind of hardware to use it for really weird
purposes. We might wanna consider adding a module parameter to disable
the magic DMI table. Or do we expect them to always compile their own
kernel and know where to fix this? Thoughts?

Regards

Marcel


