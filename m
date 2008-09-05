Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYIEMok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYIEMok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYIEMod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:44:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:27107 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYIEMoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TqlN9STeYUcfS8dOq3FCDPxUrdBenRQHiUqstthcBww7dFkXQ6ccuE5IeZHNHGGUrP
         a93jTymIM0Xi9SUhUyOfWp8xSc1jH3n3PyfYLxLZPSb387cCpiGTiAXLQOe74vD6OGYG
         3qVW8fw/18AcvuMKN3VpNcXs1EiwqGTEbWPg8=
Message-ID: <38b2ab8a0809050544l1914530clec53494e12c77ff5@mail.gmail.com>
Date: Fri, 5 Sep 2008 14:44:30 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: qestion about I2C_CLASS_HWMON flag
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
In-Reply-To: <20080905112056.44b7b910@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
	 <38b2ab8a0809040105j7ae3aca8xd334a4d203d9415b@mail.gmail.com>
	 <20080904103707.557ac764@hyperion.delvare>
	 <38b2ab8a0809040149u2bc0342h5c32b87f9277322f@mail.gmail.com>
	 <20080904120855.7e7b9720@hyperion.delvare>
	 <38b2ab8a0809050157yfb21b08v23ae368d3337c1ca@mail.gmail.com>
	 <20080905112056.44b7b910@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 11:20 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Fri, 5 Sep 2008 10:57:56 +0200, Francis Moreau wrote:
ags probably are useful, but they're are hard coded in adapters...
>
> Nothing prevents you from setting the class flags based on
> platform-specific information if you have a need for that.
>

Just to be sure, do you mean by hacking the adapter source code ?

> That being said, in cases where you have that level of information
> about which devices are present on the I2C bus,

Isn't the case for most of all embedded platforms ?

> you probably want to
> declare the I2C devices at the platform level, and not rely on probing
> at all (so .class is 0).

do you mean by using I2C_BOARD_INFO ?

Thanks
-- 
Francis
