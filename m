Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXCUSRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXCUSRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbXCUSRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:17:46 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:43896 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbXCUSRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M0oRAcH5ErleHusI/JrfhcyPU7lEJrt1SAUnfTRXBkgoc6sqJS8e6p4lKfgjzmJZGfsFDqtN1PHynJW74go4qcy+T38vxUoiEb2R6zc2HGU/miuz2IlMU+GhtsaTrRVWswn3eeb4yftCAOVIYyMI/y934S7OIJ7nCE60XOcICIE=
Message-ID: <b6c5339f0703211117m70d01240mdfe1c0798d3296e2@mail.gmail.com>
Date: Wed, 21 Mar 2007 14:17:42 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Cc: khali@linux-fr.org, "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1174471688.5648.56.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174471688.5648.56.camel@roc-desktop>
X-Google-Sender-Auth: 7b69a37057368c52
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +config I2C_BLACKFIN_TWI
> +       tristate "Blackfin TWI I2C support"
> +       depends on I2C && (BF534 || BF536 || BF537)
> +       help
> +         This is the TWI I2C device driver for Blackfin 534/536/537.
> +         This driver can also be built as a module.  If so, the module
> +         will be called i2c-bfin-twi.

Pardon my ignorance, but is there any reason to call it "Blackfin TWI"
as opposed to just "Blackfin" since TWI and I2C mean the same thing?
It lends itself to some redundancies such as:

> +       pr_info("I2C: Blackfin I2C TWI driver\n");

-Bob
