Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbXENDo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbXENDo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 23:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbXENDoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 23:44:21 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:8440 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbXENDoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 23:44:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AutRAGR3R0ZKhRO4W2dsb2JhbACHMIhFHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Giel de Nijs <giel@caffeinetrip.com>
Subject: Re: [patch 0/2] [PATCH] input: correctly handle keys without hardware release event
Date: Sun, 13 May 2007 23:44:18 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Matt Domsch <matt_domsch@dell.com>,
       Rezwanul Kabir <rezwanul_kabir@dell.com>,
       linux-input@atrey.karlin.mff.cuni.cz
References: <20070511172326.008944330@caffeinetrip.com>
In-Reply-To: <20070511172326.008944330@caffeinetrip.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132344.19311.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Giel,

On Friday 11 May 2007 13:23, Giel de Nijs wrote:
> Hi,
> 
> This patch adds a soft release key mask to input_dev, to enable keyboard
> drivers to determine which keys never generate a hardware release event and
> hence add a release event after every press event of such keys. The mask is
> controlled by ioctls.

I don't think we want to add all the infrastructure for the benefit of single
driver. Can we add a quirk to atkbd and activate it based on DMI?

-- 
Dmitry
