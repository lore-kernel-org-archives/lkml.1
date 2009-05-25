Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZEYWba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZEYWba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZEYWbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:31:22 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61570 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZEYWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:31:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=O4/FcUv8HcaB55VfqXeBaDtePP28qadoWlyFweA3LAXwCPBovsjJ3QL7JMRgZ0f+Vc
         8k08RzeY+5jrmpMgW2DOMlCGVlWPq7ClwgHg6hTc1wezdGVwOLMLzZnlO1xZhsybWllP
         gsEa1fc8AKz3RIb81bgDtkObiaREAidGE3iRA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: add warning about possible HPA compatibility issue
Date: Tue, 26 May 2009 00:36:17 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, Jacob <fun2program8@yahoo.com>,
       Christopher Hogan <chris.c.hogan@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905252348.08970.bzolnier@gmail.com> <20090525232014.7b6dd7bd@lxorguk.ukuu.org.uk>
In-Reply-To: <20090525232014.7b6dd7bd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260036.17718.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009 00:20:14 Alan Cox wrote:
> > +static inline void ata_hpa_warn(unsigned long long first_sector,
> > +				unsigned long long last_sector)
> > +{
> > +	printk(KERN_WARNING "*** possible compatibility issue:\n"
> > +		"*** sectors %llu-%llu may be inaccessible\n"
> > +		"*** if Host Protected Area is used for filesystem data\n"
> > +		"*** (please refer to \"ignore_hpa\" module parameter)\n",
> > +		first_sector, last_sector);
> > +}
> 
> NAK - this is extremely misleading and will just randomly terrify users,
> who may then set the paramater and corrupt things like BIOS save areas.

Please propose better description.
