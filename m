Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbZDBMhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbZDBMhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZDBMhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:37:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbZDBMhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:37:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Harry Ciao <qingtao.cao@windriver.com>
Subject: Re: [v0 PATCH 5/5] EDAC: CPC925 MC platform device setup
Date: Thu, 2 Apr 2009 14:36:44 +0200
User-Agent: KMail/1.9.9
Cc: norsk5@yahoo.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-5-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-6-git-send-email-qingtao.cao@windriver.com>
In-Reply-To: <1238652440-9224-6-git-send-email-qingtao.cao@windriver.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904021436.44822.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX182Px/AmW4Fb5i1e5L4ofbHjyF0FcBwUnPdR0T
 XxNMtmpYK6BuhCKYF00v/k+mTE3rdlClkg+39zVdCkWaWHRGf4
 Lqdc+5xxOCQzs+Mcvi35Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009, Harry Ciao wrote:
> +#ifdef CONFIG_EDAC
> +#define CPC925_MC_START                0xf8000000
> +#define CPC925_MC_END          0xf8ffffff /* sizeof 16MB */
> +/* Register a platform device for CPC925 memory controller */
> +static int __init maple_cpc925_edac_setup(void)

It's not good to have these encoded as magic numbers.
Can't you find the addresses in the device tree? Maybe it's
even possible to make this an of_platform_driver if you
find a good node to bind to.

Does the driver also work on a G5 Mac, or is it limited
to the maple platform?

	Arnd <><
