Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYLJJ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYLJJ7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYLJJ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:58:58 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:40624 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbYLJJ65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:58:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEACsiP0nCTsYx/2dsb2JhbACBbM5Mgwc
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] usb: make printk messges more searchable
Date: Wed, 10 Dec 2008 10:59:00 +0100
User-Agent: KMail/1.9.9
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org
References: <20081210072921.GA18142@localhost> <200812101042.17530.laurent.pinchart@skynet.be> <200812101056.15457.oliver@neukum.org>
In-Reply-To: <200812101056.15457.oliver@neukum.org>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101059.01068.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008, Oliver Neukum wrote:
> Am Mittwoch, 10. Dezember 2008 10:42:17 schrieb Laurent Pinchart:
> > Hi Wu,
> >
> > On Wednesday 10 December 2008, Wu Fengguang wrote:
> > > Make USB printk messages long and straightforward.  One of these
> > > decorated USB error messages cost me some smart efforts to locate.
> >
> > That would make the code break the 80 columns limit.
> >
> > From "Documentation/CodingStyle":
> >
> > "The limit on the length of lines is 80 columns and this is a strongly
> > preferred limit."
>
> Too rigid an application is bad. The kernel must be greppable.

I've also been bitten by split strings when grepping kernel source code. A 
cgrep that would unsplit strings before searching them would be nice :-)

Best regards,

Laurent Pinchart
