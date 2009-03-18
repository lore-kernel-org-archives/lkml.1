Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbZCRSM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbZCRSM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZCRSMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:12:12 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56504
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842AbZCRSMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:12:08 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Date: Wed, 18 Mar 2009 13:12:00 -0500
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, linux-m68k@vger.kernel.org
References: <200903120437.03837.rob@landley.net> <200903172304.00157.rob@landley.net> <49C087F3.3080507@snapgear.com>
In-Reply-To: <49C087F3.3080507@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903181312.02047.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009 00:34:43 Greg Ungerer wrote:
> Hi Rob,
>
> Rob Landley wrote:
> > On Monday 16 March 2009 18:10:45 Greg Ungerer wrote:
> >>>>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
> >>>> fix-includes
...
> > What _should_ I have done?
>
> The git clone you have done will just get the master branch,
> and put it in a directory named fix-includes.
>
> Which is ok, but you still won't have the "fix-includes" branch.
> Do this after the clone:
>
>    git pull
> git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
> fix-includes

Ah, that did something interesting...  And the resulting headers built in 
uClibc.  (Works for me!)

confirmed-uClibc-builds-with-it-by: Rob Landley <rob@landley.net>

Thanks,

Rob
