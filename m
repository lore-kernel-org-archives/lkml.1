Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZGYSTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZGYSTE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 14:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZGYSTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 14:19:04 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:62422 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbZGYSTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 14:19:03 -0400
From: Frans Pop <elendil@planet.nl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Date: Sat, 25 Jul 2009 20:18:58 +0200
User-Agent: KMail/1.9.9
Cc: Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com> <20090725174449.GC14062@dtor-d630.eng.vmware.com>
In-Reply-To: <20090725174449.GC14062@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252019.01266.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 18:19:02.0479 (UTC) FILETIME=[631DC5F0:01CA0D54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Dmitry Torokhov wrote:
> On Wed, Jul 22, 2009 at 05:18:39PM +0200, Manuel Lauss wrote:
> > Cc: Frans Pop <elendil@planet.nl>
> > Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
> >
> > +
> > +static struct dev_pm_ops au1xmmc_pmops = {
> > +	.resume		= au1xmmc_resume,
> > +	.suspend	= au1xmmc_suspend,
> > +};
> > +
>
> Was suspend to disk tested? It requires freeze()/thaw().

Is that a regression introduced by this patch then? If so, many more of 
the recent dev_pm_ops conversion patches would need to be revisited.
