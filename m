Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYECMvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYECMvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYECMvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:51:06 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27993 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYECMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:51:06 -0400
Date: Sat, 3 May 2008 14:50:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Kay Sievers <kay.sievers@vrfy.org>, Sam Ravnborg <sam@ravnborg.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCH] modpost: i2c aliases need no trailing wildcard
Message-ID: <20080503145055.3cb9032a@hyperion.delvare>
In-Reply-To: <481C58C0.4040107@scram.de>
References: <20080502203721.70c5dc09@hyperion.delvare>
	<481C58C0.4040107@scram.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jochen,

On Sat, 03 May 2008 14:21:20 +0200, Jochen Friedrich wrote:
> Hi Jean,
> 
> > Here's a patch doing this. If nobody objects, I'll send it to Linus
> > through my i2c tree next week.
> 
> looks good to me:

Thanks for testing and reporting!

> #cat modules.alias 
> # Aliases extracted from modules themselves.
> alias i2c:dbox2-fp dbox2_fp
> alias of:N*T*Cfsl,cpm-i2c* i2c_cpm
> alias i2c:dummy i2c_core

I don't have this one, and I doubt it is really useful...

> alias i2c:saa7129 saa7127
> alias i2c:saa7128 saa7127
> alias i2c:saa7127 saa7127
> alias i2c:saa7126 saa7127

-- 
Jean Delvare
