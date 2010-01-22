Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822Ab0AVCJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0AVCJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757Ab0AVCJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:09:08 -0500
Received: from bungle.evilgeniuses.org.uk ([195.10.223.155]:58991 "EHLO
	bungle.evilgeniuses.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969Ab0AVCJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:09:07 -0500
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <4B58FD48.9020209@gmail.com>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
	 <20100121185544.GB11996@core.coreip.homeip.net>
	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
	 <4B58CBEE.5020301@gmail.com>
	 <51f3faa71001211629n1b556649t32c184e49dc32dfb@mail.gmail.com>
	 <4B58FD48.9020209@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 02:09:06 +0000
Message-ID: <1264126146.28766.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 17:20 -0800, Justin P. Mattock wrote:
> On 01/21/10 16:29, Robert Hancock wrote:
<snip>
> > cat /sys/bus/pnp/devices/*/id
> >
> > and see if any of these are present?
> >
> > PNP0303
> > PNP030b
> > FJC6000
> > FJC6001
> > PNP0f03
> > PNP0f0b
> > PNP0f0e
> > PNP0f12
> > PNP0f13
> > PNP0f19
> > PNP0f1c
> > SYN0801
> >
> 
> 
> both macbook pro, and iMac9,1
> have:
> PNP0a08
> PNP0a03

# cat /sys/bus/pnp/devices/*/id
PNP0a08
PNP0a03
PNP0c02
APP0001
PNP0200
INT0800
PNP0103
PNP0c01
PNP0c04
PNP0c02
PNP0b00

On a MacbookAir1,1

