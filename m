Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbZACEiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbZACEiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZACEiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:38:07 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:9758 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZACEiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:38:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dU9MF4rGB36aYnsBUJNxq2MPifR8o0HXZSapCHb7g3dAqGweRqFE34hNgfyI/zGijg
         xjqBPYZZELj3cQq9E0Mqu7Mtkjki/CbjDlDIk0IgRvf0u8aLKfGyea4pxslD1NxoUTKJ
         Oo2kg4ll052b2CBZty53jwkAeUnedkibuDXSw=
Message-ID: <5d5443650901022038p310f77e3ifee241080126d9b1@mail.gmail.com>
Date: Sat, 3 Jan 2009 10:08:03 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: me@felipebalbi.com
Subject: Re: [PATCH] Add TI TSC2005 Touchscreen driver
Cc: "David Brownell" <david-b@pacbell.net>, dmitry.torokhov@gmail.com,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       linux-input@vger.kernel.org, lauri.leukkunen@nokia.com
In-Reply-To: <20081208182812.GD13076@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650812080949h5aff6010mb7341f581841f126@mail.gmail.com>
	 <20081208182812.GD13076@frodo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felip,

Sorry for the delayed reply.

On Mon, Dec 8, 2008 at 11:58 PM, Felipe Balbi <me@felipebalbi.com> wrote:
> On Mon, Dec 08, 2008 at 11:19:53PM +0530, Trilok Soni wrote:
>> +static ssize_t tsc2005_disable_store(struct device *dev,
>> +                                  struct device_attribute *attr,
>> +                                  const char *buf, size_t count)
>> +{
>> +     struct tsc2005          *tsc = dev_get_drvdata(dev);
>> +     unsigned long res;
>> +     int i;
>> +
>> +     i = strict_strtoul(buf, 10, &res);
>> +     i = i ? 1 : 0;
>
> shouldn't this be i = res ? 1 : 0; ??

You are right, I will change this.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
