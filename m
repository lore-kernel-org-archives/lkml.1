Return-Path: <linux-kernel-owner+w=401wt.eu-S1751093AbZKNSFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbZKNSFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 13:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZKNSFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 13:05:11 -0500
Received: from senator.holtmann.net ([87.106.208.187]:33922 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZKNSFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 13:05:10 -0500
Subject: Re: [patch 0/1] Adding radio type FM
From: Marcel Holtmann <marcel@holtmann.org>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4fb5db50911140937j278584e5nf9e4d5767a44a920@mail.gmail.com>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <1258082571.7715.13.camel@violet>
	 <4fb5db50911140519q70bbdd00qb585153c4926df96@mail.gmail.com>
	 <1258216474.3299.24.camel@violet>
	 <4fb5db50911140937j278584e5nf9e4d5767a44a920@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Nov 2009 19:05:09 +0100
Message-ID: <1258221909.3299.26.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janakiram,

> I thought i would see the change first in include/linux/rfkill.h
> getting accepted and then i can add the change in core.c also.
> 
> Let me know if i can push both in the same patch.

I said that you can add RFKILL_TYPE_FM to the RFKILL subsystem, but the
input changes might not be the right ones. Since eventually the
in-kernel input support will be removed.

And I did ask if the FM button you see is a generic RFKILL toggle or a
FM specific button. Especially since you had a copy-and-paste mistake in
your patches, that code path clearly was never tested by you.

Regards

Marcel


