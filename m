Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbXCUNGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbXCUNGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXCUNGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:06:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58283 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXCUNGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:06:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: bryan.wu@analog.com
Subject: Re: [PATCH -mm 1/4] Blackfin: architecture update patch
Date: Wed, 21 Mar 2007 14:06:20 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
References: <1174471618.5648.50.camel@roc-desktop>
In-Reply-To: <1174471618.5648.50.camel@roc-desktop>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703211406.22040.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/TKG8Qd2/kUwZWF/IN1GF4VM4Y9BQuR9WkIgZ
 u6S3DQKbtqQzFTI8DYSheeJaPpP5u03bMTc+XopuCF+DFPDqPT
 Otr+R99j4VvF5aF4QnHLg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007, Wu, Bryan wrote:
> 1) Some issues are fixed according to LKML patch review.
> 2) Remove not supported BF535 code
> 3) Fixed some bugs from blackfin.uclinux.org SVN update
> Here is the updated patch for 2.6.21-rc4-mm1

One rather general but important comment:

You need to get used to providing smaller, one fix per mail, patches.
As long as the full tree is waiting in -mm, this is not as important,
as I assume that Andrew will fold the whole architecture support into
a big patch before submitting to Linus, but as soon as it's in, such
big patches will not be acceptable any more.

If you're not already doing it, look into how 'quilt' or similar tools
help you with this.

	Arnd <><
