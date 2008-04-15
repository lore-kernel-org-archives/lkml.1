Return-Path: <linux-kernel-owner+w=401wt.eu-S1765143AbYDOWhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765143AbYDOWhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbYDOWhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:37:22 -0400
Received: from filter2.host.bg ([87.120.40.156]:53194 "EHLO filter2.host.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314AbYDOWhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:37:20 -0400
Subject: Re: Bad network performance over 2Gbps
From: Anton Titov <a.titov@host.bg>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Willy Tarreau <w@1wt.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <480512BD.3060407@intel.com>
References: <1208282804.23631.27.camel@localhost>
	 <20080415201441.GE8474@1wt.eu>  <480512BD.3060407@intel.com>
Content-Type: text/plain
Organization: Hosting Ltd.
Date: Wed, 16 Apr 2008 01:36:36 +0300
Message-Id: <1208298996.23631.43.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 13:40 -0700, Kok, Auke wrote:
> Willy Tarreau wrote:
> 1) turn the in-kernel IRQBALANCE option off !
Actually it may be already removed. I remember it being under "Processor
type and features" and I currently cannot find it there for x86_64

> 2) use either the userspace `irqbalance` daemon or
> 3) set smp_affinity manually

I tried echoing 3 (assuming that CPU0 and CPU1 will share their cache,
as advised in other mails) into smp_affinity of all ethX interrupts and
no positive result was observed.

I will try disabling NAPI and limiting e1000 interrupts tomorrow.


> 
> Auke
> 
> > 
> > Regards,
> > Willy
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

