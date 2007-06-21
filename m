Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbXFUXbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbXFUXbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbXFUXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:31:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXFUXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:31:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: Writing a driver for a legacy serial device
Date: Fri, 22 Jun 2007 01:31:08 +0200
User-Agent: KMail/1.9.6
Cc: David Woodhouse <dwmw2@infradead.org>,
       Dmitry Torokhov <dtor@insightbb.com>,
       LKML <linux-kernel@vger.kernel.org>, Vojtech Pavlik <vojtech@ucw.cz>
References: <20070619190502.05d4e0c8@hyperion.delvare> <1182437233.2782.36.camel@shinybook.infradead.org> <20070621203843.044fd19a@hyperion.delvare>
In-Reply-To: <20070621203843.044fd19a@hyperion.delvare>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706220131.08954.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX187ztGrPaouietp8+TiRXgZwyBqfBQ1tiS24UN
 KukGOAbbF5jUkFUjKSXtttR/evkayfk+dDPnndHhi93sTrJfsJ
 T5626uN6eTPKmqFLsgkHw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007, Jean Delvare wrote:
> I2C bus drivers have to be implemented in the kernel, so user-space
> isn't an option for me.

Well, you could have an i2c_algorithm that exports a character device
node to user space, and then have a trivial user application that
simply relays between that and the serial port.

It's probably not much different to what you have in the end though.

	Arnd <><
