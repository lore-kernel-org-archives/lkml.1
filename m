Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbZABVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbZABVGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216AbZABVFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:05:52 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:43266 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533AbZABVFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:05:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=coiXjqIx2h1aC1aaX9oBO2lx7JZepj3c2RvY57vyYiNwju2E4sM+4j1bbUaxAIL2l9
         0Bkw3te8A9Od9FGIRwNFXfwJ/+KAVljdvD0KziOfAw4BPJkJxBtlJn72frQ31/9U81VW
         dISviF8e83trEfcAEk8D8HXw1/H4m12q6O8VI=
Message-ID: <87f94c370901021305x7ad237ear25dcd32cbe6e7d2c@mail.gmail.com>
Date: Fri, 2 Jan 2009 16:05:48 -0500
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Cc: "Mark Lord" <liml@rtr.ca>, Redeeman <redeeman@metanurb.dk>,
       piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <124360.23007.qm@web110612.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
	 <fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
	 <49580061.9060506@yahoo.com>
	 <87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
	 <124360.23007.qm@web110612.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 3:43 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> Is there a more comprehensive write-up / resource that describes the
>> current status of the overall INTEGRITY support is, especially as it
>> relates to ATA devices?
>
>
> Did you check the kernel notes on kernelnewbies when the feature went in -
> http://kernelnewbies.org/Linux_2_6_27 ?

Interesting read, but it does not really answer the questions I posed.

I did look through the 2.6.27 source I have handy and the only call to
blk_integrity_register() is in./drivers/scsi/sd_dif.c.

That leaves me with the impression that there are not any ATA devices
claiming support yet.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
