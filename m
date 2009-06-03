Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZFCH6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZFCH6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZFCH54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:57:56 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:54939 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbZFCH54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:57:56 -0400
References: <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090512060231.GB26286@liondog.tnic> <cone.1242669880.118150.4276.1000@deskpiie> <20090524192219.GA30285@liondog.tnic> <cone.1243865900.580144.4368.1000@deskpiie> <20090603073939.GB2671@liondog.tnic>
Message-ID: <cone.1244015521.698111.16292.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Wed, 03 Jun 2009 09:52:01 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Borislav Petkov writes:

>> +
>> +#define pr_fmt(fmt) "acerhdf: " fmt
> 
> This is new but it's not used anywhere. Maybe some debug leftovers?

This is the way Joe suggested, how to use printk's:
You define the pr_fmt(fmt) before any includes and you can just do 
'pr_notice("Fan control off, to enable:\n");' to printk a notice which looks 
like this: "acerhdf: Fan control off...". Same with pr_err(...) which prints 
an error.

kind regards,
--peter
