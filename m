Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYDWInh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYDWInh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYDWIn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:43:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:34638 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbYDWInS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VHPlmB5FiDmMfSo0IhZnwzu87QWGCsBONHesLihBYrXQAtAg6Ttfr8QRMVhkub9g3rdyoDiaJOCzCUDJEysbT9XvugZqqQmCNGr+YLMkMusJXKzuREENJ8+IroOsqUX40CtoSgjxvAQU5ZrnIhOX3ESuOFNPKHCXVVQT1k12G0U=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Date: Wed, 23 Apr 2008 11:43:10 +0300
User-Agent: KMail/1.9.9
Cc: Matthew <jackdachef@gmail.com>, linux-acpi@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <200804182151.49021.lenb@kernel.org>
In-Reply-To: <200804182151.49021.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804231143.10875.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 19 April 2008 04:51:48 Len Brown wrote:
> On Friday 18 April 2008, Matthew wrote:
> > Hi everyone, hi Linus,
> > 
> > congratulations on this new great kernel-release :)
> > 
> > I've another "regression" to report for 2.6.25:
> > 
> > it's concerning much higher temperatures being read out by the
> > "coretemp" kernel-module in comparison to 2.6.24* series
> > 
> > e.g. where temperatures were around 40-47°C they are now constantly
> > jumping around 55-70°C (even in idle !)

I just updated from 2.6.24 to 2.6.25
(I usually follow whole development cycle, but I was very busy, so I skipped 2.6.25 cycle)

I confirm this.
I *know* that temperatures reported now are wrong.

The reason is that bios did report same temperatures as coretemp in 2.6.24,
moreover some time ago I have run a cpu tool (don't remember its name) on windows
which similar to coretemp reads from each core directly, sensor data , 
and I noticed that temperature that bios reports is exactly the average 
temperature of both cores
(I had to run this on windows - intel haven't released 
drivers for their QST for temperature monitoring from bios - very sad)

And the driver did say in kernel log that TJMAX is 85C

Lets at least make a kernel option to override tjmax?

Best regards,
	Maxim Levitsky
