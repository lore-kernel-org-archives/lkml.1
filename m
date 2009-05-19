Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZESGxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZESGxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZESGwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:52:55 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:36881 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZESGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:52:54 -0400
References: <cone.1240858632.795110.5316.1000@onepiie> <20090428072519.GA12170@liondog.tnic> <1240913055.29860.14.camel@maxim-laptop> <cone.1240949852.549814.7466.1000@mentalhome> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090512060231.GB26286@liondog.tnic> <cone.1242669880.118150.4276.1000@deskpiie> <1242678032.1572.122.camel@Joe-Laptop.home>
Message-ID: <cone.1242715674.319169.6240.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Joe Perches <joe@perches.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Tue, 19 May 2009 08:47:54 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Joe Perches writes:

>> +#define acerhdf_printk(loglevel, fmt, args...) \
>> +	printk(loglevel "acerhdf: " fmt, ## args);
>> +
>> +#define acerhdf_notice(fmt, args...) \
>> +	acerhdf_printk(KERN_NOTICE, fmt, ## args);
>> +
>> +#define acerhdf_error(fmt, args...) \
>> +	acerhdf_printk(KERN_ERR, fmt, ## args);
> 
> Could you please not create new prefixes for printk?
> 
> I think:
> 
> #define pr_fmt(fmt) "acerhdf:" fmt
> and use of pr_err and pr_notice would be better.

I could do that. Just curious, is there any deeper reason? Or does it just feel wrong in some matter?

best regards,
--peter
