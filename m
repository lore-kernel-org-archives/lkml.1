Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXEXBY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXEXBY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760965AbXEXBYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:24:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:2956 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760831AbXEXBYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=d+RGteSatD4btCTATcVu/9753CWNUhP3xAAvbxC4FuuK+rlmDftMFxBPz53IwKHCyTNrEzpSHXgZyLHk7fuvXsv7oaME0e4BBVa5kvhh2hW4U/oXCr8pkmpSz/HUrWSMeb/4GQ/dvRPDnESbsmAIBuK9xlJ+wcQ7aGdqfQBZaTE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dave Jones <davej@redhat.com>
Subject: Re: Add Seagate STT20000A to DMA blacklist.
Date: Thu, 24 May 2007 02:33:39 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <20070521145042.GA6957@redhat.com>
In-Reply-To: <20070521145042.GA6957@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705240233.39209.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007, Dave Jones wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=1044
> has been open for _four_ years with a patch available.
> Here's a rediffed version of the same.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Uh, it seems that this fix got stuck in the kernel "black hole"
bugzilla.  Thanks for finding and resurrecting it.  

I've just applied the bigger DMA blacklist update from
Junio C Hamano and it also covers this device.

Bart
