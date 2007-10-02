Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbXJBRSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbXJBRSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbXJBRSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:18:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:52917 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbXJBRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=lBadJE9+b02vsBF/aZjFq9at9o8YQNPNRNeHRcPeFl+pTfSZVuKyNWS/cWQzRsEUoiT/+AYneiVaF09xdCQlkhW9yyQ+Qmn9i7Xvm2yhpwIJzw1pjsKYzN3kQBrbeh+/a2vutOGNV6u/BkdMHgKCVKVHKn8X1WRpuLQ42zlQx3Q=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Greg KH <greg@kroah.com>
Subject: testers needed for drivers/usb/misc/emi*.c
Date: Tue, 2 Oct 2007 18:18:22 +0100
User-Agent: KMail/1.9.1
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
References: <200709141135.35239.vda.linux@googlemail.com> <200710021018.13905.vda.linux@googlemail.com> <20071002163532.GA12526@kroah.com>
In-Reply-To: <20071002163532.GA12526@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021818.22236.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 17:35, Greg KH wrote:
> > > > > > I suggest the following optimizations:
> > > > > > 
> > > > > > Change structure to
> > > > > > 
> > > > > > typedef struct _INTEL_HEX_RECORD
> > > > > > {
> > > > > >         __u8   type;
> > > > > >         __u8   length;
> > > > > >         __u16   address;
> > > > > >         __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
> > > > > > } INTEL_HEX_RECORD __attribute__((__packed__));
> > > > > 
> > > > > Only if you redo the whole firmware image too :)
> > > > 
> > > > I did. It wasn't hard.
> > > 
> > > Great, send me a patch then :)
> > 
> > Here is it. Sending off-list due to size.
> > 
> > emi.code.patch contains changes to firmware loading code.
> > emi.fw.patch.bz2 contains modified firmware images.
> > 
> > I don't have this hardware, thus I wrote test programs which
> > mimic firmware loading in userspace (they dump filrmware
> > in hex to stdout). See testing.tar.bz2.
> 
> Can you find someone with this hardware to test this patch?  I'll not be
> able to take it until you do as the device might be assuming some of
> these firmware requirements that you changed.

No, I don't know any users who have this device.

Changing subject and CCing lkml, just in case.
--
vda
