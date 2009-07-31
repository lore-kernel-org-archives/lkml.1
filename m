Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZGaOeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZGaOeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZGaOeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:34:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:49724 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZGaOeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VBi+TMTCQgviTnn+glfFobRN52TbpFILumxKcnHQ7DDinLesNawNPX4XdixXlZhZJq
         /i7hziND6BL4wAKXsEBXmxntezhUnwk2LjRziSmnhSJF6aZYODoeTMx9cYQayKOp2vDw
         IgcVDXktR+tiY3QH3C2Kc02DvJJ0aIsSHsLi0=
MIME-Version: 1.0
In-Reply-To: <b90c0690907310722w100a6672h769212ddee840192@mail.gmail.com>
References: <1249044918-695-1-git-send-email-quadros.roger@gmail.com>
	 <20090731131005.GE17091@sirena.org.uk>
	 <74d0deb30907310625u128ea22cu6fecca53c4a23d40@mail.gmail.com>
	 <20090731133437.GF17091@sirena.org.uk>
	 <b90c0690907310643n432c4504i1df5abaf8118e0b7@mail.gmail.com>
	 <20090731135036.GA626@rakim.wolfsonmicro.main>
	 <b90c0690907310713w5c8b7fe3l4253f03f78f06491@mail.gmail.com>
	 <20090731141547.GA6505@rakim.wolfsonmicro.main>
	 <b90c0690907310722w100a6672h769212ddee840192@mail.gmail.com>
Date: Fri, 31 Jul 2009 17:34:22 +0300
Message-ID: <b90c0690907310734g626896e8weccea8acbfaeae30@mail.gmail.com>
Subject: Re: [PATCH] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: Roger Quadros <quadros.roger@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 5:22 PM, Roger Quadros<quadros.roger@gmail.com> wrote:
> On Fri, Jul 31, 2009 at 5:15 PM, Mark
> Brown<broonie@opensource.wolfsonmicro.com> wrote:
>> On Fri, Jul 31, 2009 at 05:13:23PM +0300, Roger Quadros wrote:
>>
>>> OK I got what you meant now. If we use the use_gpio_enable flag then there would
>>> not be any problem even if GPIO is set to 0 ignorantly. Because in
>>> that case use_gpio_enable will
>>> also be set to zero.
>>> So, I feel we should keep use_gpio_enable as it is in the original patch.
>>
>> There's no in-tree users to care about and the use_gpio_enable thing is
>> just ugly - it's not worth carrying it around for ever just for this.
>>
>
> OK. I will remove use_gpio_enable then.
>

Also, if regulator register fails then we should free the GPIO
before goto err_name
