Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbYIVMgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbYIVMgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYIVMfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:35:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:19857 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbYIVMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I8ociBQXBlUv70JvDxpzgezNsmhHNWRICugM4Oozx35Tc3dag1/fVAFIlIWYnXM7aH
         xC3TSltX1bvtGw02O2KoBNy6w1UfbkRDeAGRbqRSiWlEfQlO0epubC3b0arMKuY7+cIA
         NYVRU8vRn+mQ0lj5d9i+XFOcXOWdwU+6/CFxU=
Message-ID: <961aa3350809220535w6ef5f410wc154536dda6194be@mail.gmail.com>
Date: Mon, 22 Sep 2008 21:35:49 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Carlos Corbacho" <carlos@strangeworlds.co.uk>
Subject: Re: [PATCH] acer-wmi: add error checks in module_init
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
In-Reply-To: <20080922022529.GA3009@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809211853.19889.carlos@strangeworlds.co.uk>
	 <20080922022529.GA3009@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I forget to CC)

2008/9/22 Akinobu Mita <akinobu.mita@gmail.com>:
> On Sun, Sep 21, 2008 at 06:53:19PM +0100, Carlos Corbacho wrote:
>> On Sunday 21 September 2008 15:29:59 Akinobu Mita wrote:
>> > This patch fixes these bugs by using platform_device_register_simple()
>>
>> [Adding Greg KH to CC - 2nd time lucky...]
>>
>> Last I heard, platform_device_register_simple() was in the process of being
>> deprecated and then slated for future removal. Has this changed?
>
> I didn't know about that plan. But if platform_device_alloc/add is
> more preferable API than platform_device_register_simple().
> I'll amend those patches and resend them.

The number of platform_device_register_simple() is not decreasing.
So I think the removal plan for platform_device_register_simple is not
started (yet).

grep -r platform_device_register_simple 2.6.XX | wc -l

2.6.20: 64
2.6.21: 77
2.6.22: 66
2.6.23: 76
2.6.24: 80
2.6.25: 87
2.6.26: 83
2.6.27-rc7: 88
