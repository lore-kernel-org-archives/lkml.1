Return-Path: <linux-kernel-owner+w=401wt.eu-S1763279AbZALWyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763279AbZALWyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759971AbZALWpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:45:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759656AbZALWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:45:12 -0500
Date: Mon, 12 Jan 2009 14:44:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, sameo@openedhand.com
Subject: Re: [PATCH V3 0/7] PCF50633 support
Message-Id: <20090112144434.eeb1640d.akpm@linux-foundation.org>
In-Reply-To: <20090105181242.7559.30087.stgit@fedora.yogi>
References: <20090105181242.7559.30087.stgit@fedora.yogi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 23:42:42 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> The following series implements support for NXP PCF50633. It's basically
> an I2C device with 9 regulators, an ADC, a PMIC, a Battery Charger
> and a RTC.
> 
> This chip is used in Openmoko Neo Freerunner mobile phone.
> 
> The specs are open and are available at 
> http://people.openmoko.org/tony_tu/GTA02/datasheet/PMU/PCF50633DS_02.pdf
> 
> ---
> Balaji Rao (7):
>       mfd: PCF50633 core driver
>       mfd: PCF50633 adc driver
>       mfd: PCF50633 gpio support
>       rtc: PCF50633 rtc driver
>       power_supply: PCF50633 battery charger driver
>       input: PCF50633 input driver
>       regulator: PCF50633 pmic driver

You have patches here which should strictly be merged by various
different subsystem trees.  That gets tricky because presumably there
are dependencies.

What _are_ the dependencies here?  Do patches 2-7 depend upon #1, perhaps?

If so, then one approach would be to merge the first patch into
mainline now then trickle the rest out into subsystem trees.

Or, with suitable acks, I can merge the lot.  Perhaps into 2.6.29..

