Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbZJSVLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbZJSVLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZJSVLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:11:00 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.26]:50179 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557AbZJSVK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:10:59 -0400
References: <20091019102116.222ff9c3.peter@piie.net> <9ea470500910191151j370cec68w67ee8e31f42f3303@mail.gmail.com>
Message-ID: <cone.1255986667.852662.3188.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org,
       Andreas Mohr <andi@lisas.de>
Subject: Re: [Patch] acerhdf: Return temperature in milidegree
Date: Mon, 19 Oct 2009 23:11:07 +0200
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

> Hi,
> 
> On Mon, Oct 19, 2009 at 10:21 AM, Peter Feuerer <peter@piie.net> wrote:
>> what do you think about this patch?
> 
> I don't think it is worth the trouble. Just compare the changes your
> patch introduces with a simple
> 
>  temp * 1000
> 
> you can do in userspace.
> 
> If this were a standard interface then maybe the changes could be
> warranted but it doesn't seem like so...
> 

I just had a look at the documentation concerning this topic: 

Documentation/thermal/sysfs-api.txt:162

temp           Current temperature as reported by thermal zone (sensor)
            Unit: millidegree Celsius
            RO
            Required


It is expected to be in millidegree, so I think we should discuss, modify 
and apply the patch.

regards,
--peter
