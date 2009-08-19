Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZHSQ3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZHSQ3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZHSQ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:29:49 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:24380 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbZHSQ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:29:48 -0400
Subject: Re: [PATCH] staging/wlan-ng: Convert firmware loading to load
 binary ihex format
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090819154437.GA729@kroah.com>
References: <1250665599.4545.3.camel@localhost>
	 <20090819154437.GA729@kroah.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 17:20:51 +0100
Message-Id: <1250698851.4323.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=77gSv6d_8poA:10 a=NLZqzBF-AAAA:8 a=4LfcpmYkVpcdvqRNO00A:9 a=lL-L4dknxU0NDalZ6qsA:7 a=2pkFQK9VfCjo0ILLUorBvyGZT1MA:4 a=_dQi-Dcv4p4A:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I plan to give the various distributions a utility to pre-compile the
firmware. It is based on ihex2fw.c.

I don't think the firmware will ever be accepted into linux-firmware
because the original licensing cannot be established.

Karl

On Wed, 2009-08-19 at 08:44 -0700, Greg KH wrote:
> On Wed, Aug 19, 2009 at 08:06:39AM +0100, Karl Relton wrote:
> > Convert prism2_usb firmware loading to load firmware in pre-compiled
> > binary 'ihex' format rather than ascii 'srec' format. This moves the
> > srec processing and sorting of records out of kernel space into a
> > pre-compiler. The driver now just works with the binary image, but
> > still does the 'pda plugging' of that image at runtime, as required
> > by the prism hardware.
> > 
> > Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>
> 
> 
> Are the firmware images updated somewhere?  Like in the linux-firmware
> tree?
> 
> thanks,
> 
> greg k-h
> 

