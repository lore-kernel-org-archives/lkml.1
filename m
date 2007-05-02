Return-Path: <linux-kernel-owner+w=401wt.eu-S2993209AbXEBW2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993209AbXEBW2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993208AbXEBW2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:28:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993209AbXEBW2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:28:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] tty add compat_ioctl method
Date: Thu, 3 May 2007 00:28:45 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1177620717.5060.11.camel@amdx2.microgate.com> <200705022355.38975.arnd@arndb.de> <463918BF.1050904@microgate.com>
In-Reply-To: <463918BF.1050904@microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030028.46140.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18xqnZntH5DbNEgeJDVFWdjuffngowigxGXDVw
 ayf43lPAbkEFMB30umzWClSCLq/ZvhjEYbnedrYTgH96ppdQPl
 lYpFJlBQ2StespDM4Jmhg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007, Paul Fulghum wrote:
> 
> > declarations should never be hidden inside of an #ifdef. If you want to be
> > extra clever here, you can do
> 
> OK, I have no problem with that.
> A declaration without implementation won't generate a warning?

You only get a warning for static declarations without an implementation,
not for globals.

	Arnd <><
