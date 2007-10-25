Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbXJYLJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbXJYLJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXJYLJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:09:38 -0400
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:49378 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754758AbXJYLJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:09:37 -0400
Date: Thu, 25 Oct 2007 13:09:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/f75375s.c: buggy if()
Message-ID: <20071025130934.7b38d363@hyperion.delvare>
In-Reply-To: <20071024115034.GA5797@kos.to>
References: <20071017195439.GD3778@stusta.de>
	<20071017204508.GA32110@kos.to>
	<20071018133744.GC3526@jupiter.solarsys.private>
	<20071019143754.0aa4483b@hyperion.delvare>
	<20071024115034.GA5797@kos.to>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Riku,

On Wed, 24 Oct 2007 14:50:34 +0300, Riku Voipio wrote:
> On Fri, Oct 19, 2007 at 02:37:54PM +0200, Jean Delvare wrote:
> > Take a look at the w83781d
> > driver for an example.
> 
> Btw, I think your example code has a indentation bug:
> 
> 		if (kind != w83781d)
> 			err = sysfs_chmod_file(&dev->kobj,
> 				&sensor_dev_attr_temp3_alarm.dev_attr.attr,
> 				S_IRUGO | S_IWUSR);
> 			if (err)
> 				return err;

Indentation is correct, but curly braces are missing! Nice catch,
thanks for reporting. It happens to be harmless in this specific case,
but it still needs fixing. I'll submit a patch shortly.

-- 
Jean Delvare
