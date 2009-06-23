Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbZFWXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbZFWXDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZFWXDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:03:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37341
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbZFWXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:03:07 -0400
Date: Tue, 23 Jun 2009 16:03:11 -0700 (PDT)
Message-Id: <20090623.160311.43292080.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: elendil@planet.nl, bzolnier@gmail.com, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: Improve "weird block size" error message
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090623080223.GA19253@liondog.tnic>
References: <200906230951.24615.elendil@planet.nl>
	<20090623075733.GA14790@liondog.tnic>
	<20090623080223.GA19253@liondog.tnic>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Tue, 23 Jun 2009 10:02:23 +0200

> On Tue, Jun 23, 2009 at 09:57:33AM +0200, Borislav Petkov wrote:
>> On Tue, Jun 23, 2009 at 09:51:23AM +0200, Frans Pop wrote:
>> 
>> [..]
>> 
>> > ---
>> > From: Frans Pop <elendil@planet.nl>
>> > Subject: ide-cd: Improve "weird block size" error message
>> > 
>> > Currently the error gets repeated too frequently, for example
>> > each time HAL polls the device when a disc is present. Avoid that
>> > by using printk_once instead of printk.
>> > Also join the error and corrective action messages into a single line.
>> > 
>> > Signed-off-by: Frans Pop <elendil@planet.nl>
>> > Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
 ...
> Acked-by: Borislav Petkov <petkovbb@gmail.com>

Applied, thanks!
