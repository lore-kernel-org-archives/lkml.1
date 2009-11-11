Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZKKUHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZKKUHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:07:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZKKUHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:07:00 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:50415 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbZKKUG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:06:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OUKtkNqAxF6GJyKHyw2crw/qL/oU0t0tgemEHreYtBokA1RUA8Ofq3D9VP7OukzeIg
         5n4WstvUTVvwOLZT+cZfRi3y4CCygadoEOAf+fE1uh7pi55Tio2ExZXhDQditz8cQdIN
         KS/gdqqSYnLvReg/26TFk4J3EmRvXUwpl5QkM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0911111002220.6957@p34.internal.lan>
References: <alpine.DEB.2.00.0911111002220.6957@p34.internal.lan>
Date: Wed, 11 Nov 2009 12:07:01 -0800
X-Google-Sender-Auth: b368205947cae72a
Message-ID: <1f1b08da0911111207ud6d8f09s8b1f5b6c26375d64@mail.gmail.com>
Subject: Re: Kernel: 2.6.31.5: CE: hpet increasing min_delta_ns: What do these 
	messages mean?
From: john stultz <johnstul@us.ibm.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 7:06 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I see these messages in my kernel log: (2.6.31.5)
>
> [   48.886129] CE: hpet increasing min_delta_ns to 15000 nsec
> [ 3258.107039] CE: hpet increasing min_delta_ns to 22500 nsec
> [53705.451463] CE: hpet increasing min_delta_ns to 33750 nsec

Basically it means setting the hpet timer interrupt failed because the
time it took to set it was more then the time requested.  Why its
taking so long is an open question, but we're looking into it in the
following bug:

http://bugzilla.kernel.org/show_bug.cgi?id=14426

thanks
-john
