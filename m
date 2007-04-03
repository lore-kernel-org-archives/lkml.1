Return-Path: <linux-kernel-owner+w=401wt.eu-S965528AbXDCJmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528AbXDCJmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 05:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966150AbXDCJmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 05:42:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965528AbXDCJma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 05:42:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 11:41:49 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <461178D9.402@goop.org> <46117F72.6020506@zytor.com>
In-Reply-To: <46117F72.6020506@zytor.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704031141.50045.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18B44/fhQ1v1w50VZxFOQuB4UhkW1wWczpBC/t
 G/2nEZK/Exq6SUNle4aDBqotGjLwMTvNEf2Rkg2dZCnrnDgO/1
 Vg4GjAOhFpofXIAuyLKtQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007, H. Peter Anvin wrote:
> However, one probably wants to think about what the heck one actually 
> means with "virtualization" in the absence of a lot of this stuff.  PCI 
> is probably the closest thing we have to a lowest common denominator for 
> device detection.

I think that's true outside of s390, but a standardized virtual device
interface should be able to work there as well. Interestingly, the
s390 channel I/O also uses two 16 bit numbers to identify a device
(type and model), just like PCI or USB, so in that light, we might
be able to use the same number space for something entirely different
depending on the virtual bus.

	Arnd <><
