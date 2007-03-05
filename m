Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbXCEPqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbXCEPqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933550AbXCEPqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:46:10 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:3924 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547AbXCEPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=imBd/CMLnDVj8L4LELOiB7QRAeFQtO0K8RlSSDFCxzW3j2ZtukFwY20ypD5oM0bQCKL+SzCK04hQa8KOdGxyotdhurQrbshqz6ECWnQ6lqRLcbdc1lHlB5DySlHTgh2Hv1Y/SLjvsqXL1KKreSC8gkRyxqzAqcqE/75arwVQ7TI=
Message-ID: <45EC3B3F.7020509@gmail.com>
Date: Tue, 06 Mar 2007 00:46:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATA] Failed to set xfermode on LITE-ON LTR-48246S
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070227135838.GA4328@titan.lahn.de> <45EB9822.40300@gmail.com> <20070305103840.GA4381@titan.lahn.de>
In-Reply-To: <20070305103840.GA4381@titan.lahn.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Matthias Hahn wrote:
> On Mon, Mar 05, 2007 at 01:10:10PM +0900, Tejun Heo wrote:
>> Philipp Matthias Hahn wrote:
>>> As reported by John Williams and others like in
>>> http://www.mail-archive.com/linux-ide@vger.kernel.org/msg03088.html
>>> I too have a problem with 2.6.20.1 using ata_piix not detecting the
>>> CD-ROM any more. Applying the patch from
>>> http://lkml.org/lkml/2007/2/12/24 did not help, but additionally
>>> applying
>>> http://readlist.com/lists/vger.kernel.org/linux-kernel/45/228948.html
>>> made it work. Here's the relevant extra debugging output:
>> * Did it work with previous kernels?
> 
> Previously I was using the old IDE modules just fine, it was only with
> 2.6.20 that I did the switch to libata and encountered the problem.
> 
>> * Does applying the attached patch over unpatched 2.6.20.1 fix the problem?
> 
> Yes, it seems to fix it. (testes on top of the first patch mentioned
> above, but witheout the second one.).
> If I should test it as the sole patche, just mail me again please.

Yeap, please test it on top of vanilla kernel to verify that the patch
proper fixes the problem.

Thanks.

-- 
tejun
