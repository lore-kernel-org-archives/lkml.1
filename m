Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZIAVzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZIAVzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 17:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZIAVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 17:55:35 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:43607 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZIAVze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 17:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rrFlaZkOhqMcR92uHD3ara4xJY06vpy+OzMekEdBJAKhOvyI/aBJIu7KWSr6glU8hl
         ywZOaFUCphV/y58r0vf9DlqSQTbr6iivEJOFgUosEkLplxcZQaDzxoZQP49BHrZkquzr
         0nJc4LcFKmJias3PLbqWEZweljhR8jHzkDjEI=
MIME-Version: 1.0
In-Reply-To: <20090901134751.GR19719@n2100.arm.linux.org.uk>
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com>
	 <20090901134751.GR19719@n2100.arm.linux.org.uk>
Date: Tue, 1 Sep 2009 23:55:35 +0200
Message-ID: <63386a3d0909011455l62c19863rc8caedeae54cf4c5@mail.gmail.com>
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/1 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Sun, Aug 30, 2009 at 11:29:09PM +0200, Linus Walleij wrote:
>> This adds support for the regulators found in the AB3100
>> Mixed-Signal IC.
>
> Not sure why I was cc'd on this, but only one comment from me...

For the boardinfo part mainly and for something fun to do when
you're back from your vacation... (welcome back!)

>> +/* Preset (hardware defined) voltages for these regulators */
>> +#define LDO_A_VOLTAGE 2750000
>> +#define LDO_C_VOLTAGE 2650000
>> +#define LDO_D_VOLTAGE 2650000
>> +
>> +int ldo_e_buck_typ_voltages[] = {
>> +     1800000,
>> +     1400000,
>> +     1300000,
>> +     1200000,
>> +     1100000,
>> +     1050000,
>> +     900000,
>> +};
>> +
>> +int ldo_f_typ_voltages[] = {
>> +     1800000,
>> +     1400000,
>> +     1300000,
>> +     1200000,
>> +     1100000,
>> +     1050000,
>> +     2500000,
>> +     2650000,
>> +};
>> +
>> +int ldo_g_typ_voltages[] = {
>> +     2850000,
>> +     2750000,
>> +     1800000,
>> +     1500000,
>> +};
>> +
>> +int ldo_h_typ_voltages[] = {
>> +     2750000,
>> +     1800000,
>> +     1500000,
>> +     1200000,
>> +};
>> +
>> +int ldo_k_typ_voltages[] = {
>> +     2750000,
>> +     1800000,
>> +};
>
> Is there a reason for these to be globally visible?

No. Fixed it and also even made them const * const.

Thanks!

Linus Walleij
