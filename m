Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYGPHux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYGPHux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYGPHup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:50:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:23048 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYGPHuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k3blse3lYdgtLTanzzYFur4iMJRdWXdK5/1mWH/d7Ky1ixCGIGUYW7IVlBi38qZqsf
         XazDNn6v19t3+kTRbBjwJbsgYmAxcXghV4pz1DyQVdSlnMBpMjzx4etQ224hTFZUAjPd
         vjcaJRw9Ono4y+lPsFCd+g9WFgzFICYCDGbwA=
Message-ID: <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com>
Date: Wed, 16 Jul 2008 07:50:43 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807151252w7edcea19t8cec5ec5f958c7c0@mail.gmail.com>
	 <20080715231118.GA26807@bromo.msbb.uc.edu>
	 <dd18b0c30807151726i622dabceve31828460085ee57@mail.gmail.com>
	 <20080716012427.GA27398@bromo.msbb.uc.edu>
	 <dd18b0c30807152005g3c58001br7182f7670d6247db@mail.gmail.com>
	 <20080716035830.GA27935@bromo.msbb.uc.edu>
	 <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com>
	 <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 7:44 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> I looked at your dmesg from 2.6.25.10
>
> it tried to use mmconfig, and later fall back to conf1, because
> 1. your MCFG said it support bus [0,255], and range will be
> [0xf0000000, 0xffffffff]
> 2. firmware only reserve [0xf0000000, 0xf4000000)
>
> and 2.5.25 will not check acp reserved range.
>
> from 2.6.26, it will check if the [0xf0000000, 0xffffffff] is reserved
> via acpi dsdt _crs?
> it will fail too.
>
> So MCFG table is broken.
>
> You need to get firmware update from your vendor.
>
> or we need to put that system on DMI check to change end_bus_number
> from 0xff to 0x3f
>
> ps: mem=2g will not work, it will can not change mcfg table etc... you
> need take out 1G ram out.
>
> YH
>

Well shit man, that sucks...
how hard is it to do a DMI check?
regards;

-- 
Justin P. Mattock
