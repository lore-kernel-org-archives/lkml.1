Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZJ1VLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZJ1VLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZJ1VLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:11:47 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40991 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbZJ1VLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nU815IJTlMzTjObunNmgwWFvlTW6cdV73OYNAfmiTHZegbcjvXO6H5ftQNmQtI7NvL
         BxzXpK7wldE04HIcTugJWFTb47GIKqT6pakMV0BhteHW0SPdzALELQ+1UgnRnPKrkO7j
         xa/eyddT1nkoGJO4eleck/qaGv0PXDe4qJDNQ=
MIME-Version: 1.0
In-Reply-To: <20091028204628.GA8519@rhlx01.hs-esslingen.de>
References: <e86b7d350910281224i7e91a1ecp9f3d15d9c36f19cb@mail.gmail.com>
	 <20091028204628.GA8519@rhlx01.hs-esslingen.de>
Date: Wed, 28 Oct 2009 16:11:51 -0500
Message-ID: <e86b7d350910281411k6dfb260dlfce76e260c797a9@mail.gmail.com>
Subject: Re: Hyperthreading on 4 core CPU DECREASES performance???
From: Igor Chudov <ichudov@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 3:46 PM, Andreas Mohr <andi@lisas.de> wrote:
>> I would like to know how can I make the scheduler to prefer to spread
>> the tasks across physical cores as opposed to bundling two on one core
>> and leaving some cores idle.
>
> Did you have /sys/devices/system/cpu/sched_smt_power_savings activated?

Andreas, no, I did not have it activated, it was set to 0. I did check
it before and double checked it now.
