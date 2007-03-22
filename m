Return-Path: <linux-kernel-owner+w=401wt.eu-S965757AbXCVFja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965757AbXCVFja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965760AbXCVFja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:39:30 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:20986 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965757AbXCVFj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mP0p+ptC9f2A1CngSUQ2vIKo+DykcuPYXgnAEziAVdpmRnG1o+/wpQQeD8NnpoqTyQrAzanAxbceo8Eew0C+1YzR/5jeOnFQpDuOxzt1ekzJGAurVoCw9PtoyqHjcewRQLj13Sc3t7/TyyUPzQP3xmzqcnz7w5l4xLwY7RF4nGw=
Message-ID: <8bd0f97a0703212239n3edb9a44waa0994e3cffe48d8@mail.gmail.com>
Date: Thu, 22 Mar 2007 01:39:28 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Cc: "Bryan Wu" <bryan.wu@analog.com>, "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070321202231.2eac1cf9.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174471688.5648.56.camel@roc-desktop>
	 <20070321202231.2eac1cf9.khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Jean Delvare <khali@linux-fr.org> wrote:
> > +     p_adap->class = I2C_CLASS_ALL;
>
> This pretty much voids the point of these probing classes. You should
> only select the classes matching devices which may actually be probed
> for on this bus. If different boards have different needs, get the
> right classes from the platform data.

i asked about the class issue previously specifically for this bus
driver and was told that they werent really fully defined ... the
on-chip I2C interface on the Blackfin chip can handle any I2C device
which is why i added this line

any examples of how to go about doing it via boards ?  i dont see any
other I2C bus driver doing it that way ...
-mike
