Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbYIYKOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbYIYKOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYIYKOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:14:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:50368 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYIYKN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:13:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lmNIhxmIlY/vXugtMAmCM649loLnALUaqHUQLZJVnnuJHVSXoXKQ0/ixPf8NYlfvp/
         XejhTkZNJx5eYBnFgD/3snDbCxIryDPriljURB2gB6XeuYG7HKtISkMyGscvfnAqJSeP
         bUDCCj/uV+4xN9Gv9eD3Pd4+c8Dv333k6oO8g=
Message-ID: <3ae72650809250313h66b35a73u8c73ffce5b74921e@mail.gmail.com>
Date: Thu, 25 Sep 2008 03:13:58 -0700
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Drew Moseley" <dmoseley@mvista.com>
Subject: Re: [PATCH] Create PNP device attributes via dev_attrs field of struct device
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org
In-Reply-To: <48DA9702.4020106@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D95EA2.9040804@mvista.com>
	 <3ae72650809232159k20f19f2ele5acbc7ee77dfb65@mail.gmail.com>
	 <48DA774A.9010206@mvista.com>
	 <3ae72650809241203o41b62a10m31377887d44fd05e@mail.gmail.com>
	 <48DA9702.4020106@mvista.com>
X-Google-Sender-Auth: c1bd29614ff38f96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 12:37, Drew Moseley <dmoseley@mvista.com> wrote:
> Kay Sievers wrote:
>> Yeah, it looks weird to mangle the bus_type values from a device
>> routine, and set the same value again and again with every device
>> creation. Just declare the array non-static, if moving the code around
>> between files does not allow a static declaration.
>
> Updated patch.

> Signed-off-by: Drew Moseley <dmoseley@mvista.com>
> Index: linux-2.6.21/drivers/pnp/base.h

This seems not to apply. Oh, you are patching a 1.5 years old kernel?
:) Care to redo this for a recent one?

Thanks,
Kay
