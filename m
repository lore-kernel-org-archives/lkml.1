Return-Path: <linux-kernel-owner+w=401wt.eu-S968012AbYD1XFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968012AbYD1XFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967006AbYD1WjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:39:12 -0400
Received: from mail001.aei.ca ([206.123.6.130]:37743 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967001AbYD1WjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:39:11 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 18:39:10 EDT
From: Ed Tomlinson <edt@aei.ca>
To: "Kallol Biswas" <nucleodyne@gmail.com>
Subject: Re: FS performance with SD/MMC card
Date: Mon, 28 Apr 2008 18:32:26 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <438397970804281351h3fc66cb8i71840519c8e3e883@mail.gmail.com>
In-Reply-To: <438397970804281351h3fc66cb8i71840519c8e3e883@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281832.26803.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Take a look at:

http://intr.overt.org/blog/?p=66

The problem he mentions is due to dynamic cpu speed scaling to save power.  When its disabled 12.9M/s comes back...

The support for high speed is in the stock linux kernel.  Nokia's kernel drops it since some of the HW
they use for the SD card support has problems with the high speed...

Thanks
Ed 

On April 28, 2008, Kallol Biswas wrote:

> Hi,
>   Someone has asked how fast can a linux FS  write to a SD/MMC card?
> 
> Answer to this will help make a product decision.
> 
> 
> Kallol Biswas
> NucleoDyne Systems, Inc.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


