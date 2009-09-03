Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZICOSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZICOSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZICOSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:18:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:58119 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbZICOSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vogZxSyMXeasXQchRpfO2jOg0n8kkfX7J/K4QPmlzGtwx1XXNHr3+T67Uxjqkma+ZS
         BbIs10404nmz/P0OIeRueyjbo8YzcmV5OWykbljBk7aq06bjg4Bdv1ccGzEA/QcWOh5j
         WviPSZslaZieps3A0qh1eLXB8804II8gxiGpo=
MIME-Version: 1.0
In-Reply-To: <20090903115521.GB12597@tuxdriver.com>
References: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
	 <20090903115521.GB12597@tuxdriver.com>
Date: Thu, 3 Sep 2009 16:18:24 +0200
Message-ID: <a32f33a40909030718v494f8fech6ba3c854b5c84ef8@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Get rid of duplicate usb id from rt2500usb
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Amit Kucheria <amit.kucheria@canonical.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 1:55 PM, John W. Linville<linville@tuxdriver.com> wrote:
> On Thu, Sep 03, 2009 at 02:42:20PM +0300, Amit Kucheria wrote:
>> USB_DEVICE(0x148f, 0x2573) is served by the rt73usb driver where it is already
>> defined. Remove it from rt2500usb.
>>
>> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
>> Cc: Ivo van Doorn <IvDoorn@gmail.com>
>
> IIRC there are IDs that are used by different devices where rt73usb
> covers one device and the rt2500usb covers another.  Are you sure
> this is not one of those?

Yes, I believe this particular ID was already discussed some time ago
on this list. This is one of the infamous duplicate IDs. (Fortunately not
one of those infamous Linksys devices with 5 different chipsets for the
same ID).

Ivo
