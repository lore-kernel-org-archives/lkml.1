Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbZBNWJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbZBNWJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZBNWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:09:31 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44409 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZBNWJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FpoaHqorzN/M4aWE91Yq8PgucrjE2kBPVw36m229j0yXh+6xsyNgvEDHxKxkykEgLr
         PNmCpzrmBAuLmRSvoLAK7QsNrDrzDOLY7K1B0Lq130OSanexhKTSOGMgDBHx9XdZ3TJu
         8rKl2/gn4IYBMLOpXKmJ1SJ75GPKfYWMmmPTo=
MIME-Version: 1.0
In-Reply-To: <20090214215919.GA24052@kroah.com>
References: <1234641948.6609.13.camel@localhost.localdomain>
	 <20090214215919.GA24052@kroah.com>
Date: Sat, 14 Feb 2009 22:09:27 +0000
Message-ID: <8b67d60902141409q39a79e67va422846f685f969d@mail.gmail.com>
Subject: Re: [PATCH] sh: maple: Update the maple bus driver to support block 
	reads and writes
From: Adrian McMenamin <lkmladrian@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Paul Mundt <lethal@users.sourceforge.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/14 Greg KH <greg@kroah.com>:
> On Sat, Feb 14, 2009 at 08:05:48PM +0000, Adrian McMenamin wrote:
>> Greg,
>>
>> This patch updates the maple bus to support asynchronous block reads and
>> writes as well as generally improving the quality of the code and
>> supporting concurrency (all needed to support the Dreamcast visual
>> memory unit - a driver will also be posted for that).
>>
>> I have posted versions of this before but am here following the patch
>> grouping suggested and have also tested this code and unlike earlier
>> versions it shows no signs of suffering from race conditions - so I hope
>> you will be happy to queue it for inclusion.
>
> Looks good to me, but shouldn't this go through the sh maintainers
> instead?  This is their area, right?


As it's a change to a bus I thought you were the maintainer?
