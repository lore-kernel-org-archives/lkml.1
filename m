Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbZIUVpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbZIUVpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZIUVpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:45:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbZIUVpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:45:54 -0400
Date: Mon, 21 Sep 2009 14:44:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: tomaz.mertelj@guest.arnes.si, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Driver for Texas Instruments 
 amc6821 chip
Message-Id: <20090921144423.6ebf564f.akpm@linux-foundation.org>
In-Reply-To: <20090909093435.60531d95@hyperion.delvare>
References: <20090905_120834_010267.tomaz.mertelj@guest.arnes.si>
	<20090908170649.855dd1ff.akpm@linux-foundation.org>
	<20090909093435.60531d95@hyperion.delvare>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 09:34:35 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> > #define set_temp_para(name, reg)\
> > static ssize_t set_##name(\
> > 		struct device *dev,\
> > 		struct device_attribute *attr,\
> > 		const char *buf,\
> > 		size_t count)\
> > {\
> > 	return set_helper(dev, attr, buf, count, &dev->name);\
> > }
> > 
> > And then do all the real work in a common function?  Rather than
> > expanding tens of copies of the same thing?
> 
> Yes please. We got rid of macro-generated callbacks in most hwmon
> drivers a couple years ago already.

I never received an update to this patch so I'm retaining it in my tree
for now.

