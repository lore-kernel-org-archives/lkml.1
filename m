Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXGaS3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXGaS3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbXGaS3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:29:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:62581 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762996AbXGaS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BR6UnZcZGTCgzMiCeH5EwwC6M3/iiHOLOcWM62Ov35r/lyvD8Hk4cfqwOahuvlphsoXhdvaDKthmK8HvwVw+iv1LYViqcLSZw7sfU1a/GfTDpkotInQIJcOboA6eYvOi8KoFXIFcOJ2hOP5vFM9VOEBhb2OnQN+4jzHTN1aOp34=
Message-ID: <46AF7F7E.6060300@gmail.com>
Date: Wed, 01 Aug 2007 03:29:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
References: <20070705194909.337398431@intel.com>	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com>	 <1185891382.2750.8.camel@laptopd505.fenrus.org>	 <46AF4B05.4010700@gmail.com> <1185898532.2766.2.camel@laptopd505.fenrus.org>
In-Reply-To: <1185898532.2766.2.camel@laptopd505.fenrus.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> They were hardware problems.  I don't think any amount of proper
>> implementation can fix them.  I have one DVD RAM somewhere in my pile of
>> hardware which locks up solidly if any link PS mode is used and had a
> 
> and the AHCI ALPM code decides to use power savings on this device? if
> so, please give us the idents so that we can add it to the blacklist as
> the first entry... (or can buy it to check it in detail first)

Yeap, lemme check.

It's "TSSTcorpCD/DVDW SH-S183A" with firmware revision "SB01".  Wanna
check ID capability bits but 'hdparm -I /dev/sr0' is still broken and
it's already past 3 am here.  I'll report back tomorrow.

Thanks.

-- 
tejun
