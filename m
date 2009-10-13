Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbZJMUpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbZJMUpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761052AbZJMUpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:45:31 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:48703 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155AbZJMUp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=X/CeXfik8mbqql9AV5W2Fim9tk9qUaX4JY3lrdR8KlWsrqYU+xwRucmgfc6MGpoZWj
         ry9fNYAq9YAmtEYnTETYM926zpTviH+XBSOA9S/F2lc4Ygx/0fi/kueJ7+gPfpK9NEvB
         lqtsEXDbtKAwC+qRw3E8qmse16qcVwXaHR9aI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 22:42:31 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc2-00251-gd8c9210; KDE/4.3.1; x86_64; ; )
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910132121.25743.bzolnier@gmail.com> <200910132200.48569.IvDoorn@gmail.com>
In-Reply-To: <200910132200.48569.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910132242.31177.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009 22:00:48 Ivo van Doorn wrote:
> > > The rt2800pci and rt2800usb drivers cover support for rt2860/rt2870/rt3070 devices,
> > > which are present as individual drivers in the staging tree. So far it only managed
> > 
> > There are no longer individual drivers.
> > 
> > Instead there is one shared source code and two device drivers:
> > 
> > - rt2860 covering RT2860 and RT3090 devices
> > 
> > - rt2870 covering RT2870 and RT3070 devices
> 
> Cool, now you only need somebody to update those drivers to mac80211,
> and you can merge those drivers to the main drivers/net/wireless/ folder.
> 
> Can't be more happy with this progress, since that means I can finally abandon
> rt2800pci and rt2800usb which have been nothing more then a pain.

I will be glad to take over the maintenance of those two drivers if this
is so burdensome for you..
