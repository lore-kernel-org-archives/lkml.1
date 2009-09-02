Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZIBX4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZIBX4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 19:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZIBX4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 19:56:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbZIBX4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 19:56:04 -0400
Date: Wed, 2 Sep 2009 16:55:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tomaz.mertelj@guest.arnes.si
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Driver for Texas Instruments amc6821 chip
Message-Id: <20090902165502.b6710792.akpm@linux-foundation.org>
In-Reply-To: <20090831_202450_066558.tomaz.mertelj@guest.arnes.si>
References: <20090831_202450_066558.tomaz.mertelj@guest.arnes.si>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009 22:24:50 +0200
tomaz.mertelj@guest.arnes.si wrote:

> I have crafted a hwmon driver for Texas Instruments amc6821 SMB-bus 2-
> channel temperature sensor, pwm controller. This is my first linux project 
> so some corrections will be necessary.
> 

The driver looks saneish to me, but...

- The attachment uses \r\n line termination and caused me quite a bit
  of trouble before I worked out what was going on.

- The changelog is missing your Signed-off-by:.  Please read up on
  this in Documentation/SubmittingPatches.

- The driver needs lots and lots of trivial coding-style fixes. 
  Please take a look at some similar drivers and also use the
  scripts/checkpatch.pl tool.

  checkpatch says:

	total: 153 errors, 110 warnings, 874 lines checked

  which must be some sort of record ;)

  Also, some C functions have needless `\' line continuations in them.


All pretty simple stuff.  Please take a look at all that and then resend?

Thanks.

