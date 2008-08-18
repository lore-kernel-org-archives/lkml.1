Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYHRVcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYHRVcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYHRVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:32:13 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:31627 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYHRVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=OxYsI6BtnhavBvlXrryMO5F2J2jacRUbeKPzSgPWmzBc2hwPpO+cUSkwQpdehoXaI6
         UrynX4ncQIbaam/iZt4JKwzXHR8afgB+lZ39kgwSseRBLYYydz8LL7fUhqErOcNeQzWL
         2JyfpfFH1qZbVL+HSjYshemprEUHhcbVqaVgw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/5] ide debugging macros
Date: Mon, 18 Aug 2008 23:29:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com> <200808182308.38345.bzolnier@gmail.com>
In-Reply-To: <200808182308.38345.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808182329.13199.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Sunday 17 August 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here's something i've been wanting to do for a long time: debugging macros. The
> > reason for it is that i got tired of adding debug printk's everytime i'm testing
> > something so here we go.
> > 
> > The debugging macro is similar to the old ones but is one for all drivers
> > (currently only ide-floppy), is nice on branch prediction and is controlled by a
> > drive->debug_mask switch which is a module parameter and as such can be set at
> > module load time, of course. I've been thinking of adding also a sysfs attribute
> > too but can't seem to find quite the justification for it so no sysfs for now :)
> 
> if you look closely you should already find it :)
> 
> [ module parameters are exported through sysfs and it uses 0644 mask ]

Together with sysfs device-driver binding/unbinding support it
can probably substitute for lack of sysfs attribute for now. ;)

Anyway adding a proper device sysfs attribute will be trivial
(ide_dev_attrs[]) but lets wait with it until things settle down.

Thanks,
Bart
