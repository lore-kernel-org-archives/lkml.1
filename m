Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbYDRSjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbYDRSjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760213AbYDRSir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:38:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:12253 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760609AbYDRSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A6kn7lYc18MsXSrJDvJo4gyL+Wt3Mv75lR5p6wduO02jQJMT+3LT2ErzKMNok9TiDPdIeq2JQZcNub1nEmGyRMywQARKEpJ0y7m2YQjM6fo5zPFzGqqRkNGWbbP8c8Y4/zMjKgdtDYrc2VBSmKvS46JTKjYaeIbeMWETjMId+Fw=
Message-ID: <e9c3a7c20804181138p3365a15bi8e4ca442e7864259@mail.gmail.com>
Date: Fri, 18 Apr 2008 11:38:22 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: 2.6.25-mm1 (build error: driver core)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080418165641.GC21168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	 <20080418094041.86b082bb.randy.dunlap@oracle.com>
	 <20080418165641.GC21168@kroah.com>
X-Google-Sender-Auth: 7c49502079b32a3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 9:56 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Apr 18, 2008 at 09:40:41AM -0700, Randy Dunlap wrote:
>  > On Fri, 18 Apr 2008 01:47:57 -0700 Andrew Morton wrote:
>  >
>  > >
>  > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/
>  >
>  > with CONFIG_BLOCK=n:
>  >
>  > linux-2.6.25-mm1/drivers/base/core.c: In function 'device_to_dev_kobj':
>  > linux-2.6.25-mm1/drivers/base/core.c:768: error: 'block_class' undeclared (first use in this function)
>  > make[3]: *** [drivers/base/core.o] Error 1
>
>  Ah, more fun caused by Dan's /sys/dev/... patch.
>
>  Dan, this is causing a lot of problems, I'm going to drop it for now
>  until the build and run-time errors get resolved.
>

Ok, I'll have an updated version with Kay's duplicate-entry fix and a
resolution for CONFIG_BLOCK=n shortly...

>  thanks,
>
>  greg k-h
>

Regards,
Dan
