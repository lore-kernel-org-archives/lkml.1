Return-Path: <linux-kernel-owner+w=401wt.eu-S1764250AbXHAJps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764250AbXHAJps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761175AbXHAJpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:45:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:20095 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760903AbXHAJpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BvQTeabzrarkPjFgcuHOeBuS/s+AMeb6We3G1CyXbChGWF4d4/9H8kD4J65nWCkREXJnisxcW2WuJoqRt50iSxgH2crw6Q33SZdEfr++VlRYFSHJtLiArTNG0fHQU6v3Kzzds0rGRfHAQoj390JZvuzgY1I2RgxapGIWgt9B3/E=
Message-ID: <4354d3270708010245v5831610fw10ab2ff74d90ccae@mail.gmail.com>
Date: Wed, 1 Aug 2007 12:45:33 +0300
From: edwintorok@gmail.com
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Cc: "Kristen Carlson Accardi" <kristen.c.accardi@intel.com>, jeff@garzik.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, James.Bottomley@steeleye.com,
       axboe@kernel.dk, linux-scsi@vger.kernel.org
In-Reply-To: <46B043FB.5090005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070705194909.337398431@intel.com>
	 <20070705130530.5873afeb.kristen.c.accardi@intel.com>
	 <46B043FB.5090005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Tejun Heo <htejun@gmail.com> wrote:
> >
> > +	if (ata_id_has_hipm(dev->id) || ata_id_has_dipm(dev->id))
> > +		dev->flags |= ATA_DFLAG_IPM;
>
> Is it safe to use ALPM on a device which only claims to support DIPM?

I have tested on a Dell Inspiron 6400, it has ICH7-M (82801GBM) chipset.
The harddisk claims to support only DIPM, and the ALPM patches work with it.
Kristen said either DIPM or HIPM will work with ALPM accord to the
spec, see this email:
http://www.bughost.org/pipermail/power/2007-June/000691.html

--Edwin
