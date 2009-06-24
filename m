Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZFXL5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZFXL5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZFXL5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:57:39 -0400
Received: from mail-yx0-f194.google.com ([209.85.210.194]:39866 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZFXL5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:57:39 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jun 2009 07:57:38 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TqT8Gn4mz+vDkhC8MHBsfeDxCUe+HFBDJwnLefdOdwylXv6jICTtX/o+EimNe42gae
         4hlq4TmMgpva+avEPXnSEYoCqSXXOfvtmMUkk2Hym8OfTqp5IfK8yrtK3Sre7S9aBtS4
         cEiQ5F6q6A7Son6WBvZTxyMU7JC7sVEfVM8OI=
MIME-Version: 1.0
In-Reply-To: <87r5xhqzr4.fsf@deeprootsystems.com>
References: <20090610121659.27937.13560.sendpatchset@rx1.opensource.se>
	 <87r5xhqzr4.fsf@deeprootsystems.com>
Date: Wed, 24 Jun 2009 20:50:18 +0900
Message-ID: <aec7e5c30906240450w2c204b1bo8e06cdc26eaad753@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V3
From: Magnus Damm <magnus.damm@gmail.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, gregkh@suse.de,
       khilman@deeprootsystems.com, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 1:21 AM, Kevin
Hilman<khilman@deeprootsystems.com> wrote:
> Magnus Damm <magnus.damm@gmail.com> writes:
>
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> Allow architecture specific data in struct platform_device V3.
>>
>> With this patch struct pdev_archdata is added to struct
>> platform_device, similar to struct dev_archdata in found in
>> struct device. Useful for architecture code that needs to
>> keep extra data associated with each platform device.
>>
>> Struct pdev_archdata is different from dev.platform_data, the
>> convention is that dev.platform_data points to driver-specific
>> data. It may or may not be required by the driver. The format
>> of this depends on driver but is the same across architectures.
>>
>> The structure pdev_archdata is a place for architecture specific
>> data. This data is handled by architecture specific code (for
>> example runtime PM), and since it is architecture specific it
>> should _never_ be touched by device driver code. Exactly like
>> struct dev_archdata but for platform devices.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>
> Since there is no 'Feature-desired-by:' tag, I'll addd
>
> Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
>
> For PM on ARM in general, and OMAP in particular we definitely need a
> generic way to handle arch-specific data per platform_device.

Thanks, Kevin! So ARM in general or at least OMAP wants this, and so
does SuperH.

Rafael, you kindly gave feedback on earlier versions, are you ok with
this version?

Cheers,

/ magnus
