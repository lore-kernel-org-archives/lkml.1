Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZIBVjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZIBVjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZIBVjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:39:54 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58732 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZIBVjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZhzokoXTtFYbTohG5wzAYl76CTfE1RwSfNDg20NmflXcqHqCmoUkVLvbkAyKnIjeYs
         2q32eSaRhijlQEIsmNKPEs9XRp0/sDC+9lt9cHKzhRiCQsWPBrqPqIoJVP8MevBRs5bw
         ju/EE6oEy2wBedKCRPhg6UErd1Nm3cg/yg+rI=
MIME-Version: 1.0
In-Reply-To: <20090902184234.GB10581@rakim.wolfsonmicro.main>
References: <1251756324-24216-1-git-send-email-linus.walleij@stericsson.com>
	 <20090902184234.GB10581@rakim.wolfsonmicro.main>
Date: Wed, 2 Sep 2009 23:39:54 +0200
Message-ID: <63386a3d0909021439k784bc80et7e5cfa38987afefb@mail.gmail.com>
Subject: Re: [PATCH 2/2] U300 AB3100 boardinfo v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/2 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> On Tue, Sep 01, 2009 at 12:05:24AM +0200, Linus Walleij wrote:
>> This defines regulator platform data and board power
>> regulator hogs for the ST-Ericsson U300 platform.
>
> This is pretty much OK, just...
>
>> +static struct regulator_consumer_supply supply_ldo_a[] = {
>> +     {
>> +             .dev = NULL,
>> +             .supply = "vrad", /* Powers the radio */
>> +     },
>> +};
>
> Now you're using the regulator init stuff to set the voltages you should
> be able to drop most of the deviceless supplies.  I'd expect that you'd
> want to keep the CPU core supplies for cpufreq support but the others
> shouldn't need to be defined.  The names can be set in the constraints
> - if set there they will be displayed to user space which normally makes
> the diagnostics easier to follow for board users.

OK I'll drop them. I've got some other small fixups here so will push a v4
once we clarified the initsettings too.

Yours,
Linus Walleij
