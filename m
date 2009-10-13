Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbZJMSTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbZJMSTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760881AbZJMSS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:18:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:26984 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760819AbZJMSS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lBHnTXpOavRQjha4gx8I0iM2Ueizagd5yWc09pQAXI2lBlDWMxE4e4vP3MIXfmzbLa
         jrCDrM9b11DK7VrgVj2y93eZRrXb/4r+nxteMkPW+kg8Q65H8MzKuJWxe+WJZIGSZt/B
         RTYJSMFAOoSXHcg+nhkuX+G27Tqg9avb8gDcs=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 20:17:47 +0200
User-Agent: KMail/1.9.10
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910131752.52589.IvDoorn@gmail.com> <200910131927.24136.bzolnier@gmail.com>
In-Reply-To: <200910131927.24136.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910132017.47748.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 13 October 2009 17:52:52 Ivo van Doorn wrote:
> 
> > I am going to merge rt2800pci soon as well and after that I'll send a patch
> 
> Great, I've been waiting for this for a long time.
> 
> > to remove all Ralink drivers from the staging tree.
> 
> Till new drivers obtain support for all hardware currently covered by
> the unified staging drivers the latter shouldn't be removed as they
> serve well their role as a temporary solution allowing real Linux users
> to user their real hardware and as a reference material for developers
> willing to work on adding the missing bits to new drivers.

The rt2800pci and rt2800usb drivers cover support for rt2860/rt2870/rt3070 devices,
which are present as individual drivers in the staging tree. So far it only managed
to confuse developers which wanted to work on Ralink support, so I haven't found
a benefit for having those drivers in the staging tree yet. But I am sure there are plenty
of people who like the idea of having the original Ralink drivers inside the staging tree,
so they can continue debugging that, so I won't talk about the staging downsides further.
Ivo
