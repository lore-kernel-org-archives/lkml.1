Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYK0P50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYK0P50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYK0P5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:57:18 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:51666 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYK0P5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:57:17 -0500
From: Yuri Tikhonov <yur@emcraft.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH][v2] xsysace: use resource_size_t instead of unsigned long
Date: Thu, 27 Nov 2008 18:48:26 +0300
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org, "Wolfgang Denk" <wd@denx.de>,
       "Detlev Zundel" <dzu@denx.de>, "Ilya Yanok" <yanok@emcraft.com>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
References: <200811271521.27642.yur@emcraft.com> <fa686aa40811270611j58ceb6e5lffc37fc3f83d00e7@mail.gmail.com>
In-Reply-To: <fa686aa40811270611j58ceb6e5lffc37fc3f83d00e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811271848.26520.yur@emcraft.com>
X-Spam-Score: -3.7 (---)
X-Spam-Report: Spam detection software, running on the system "pacific.emcraft.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Hello Grant, On Thursday 27 November 2008 17:11, Grant Likely
	wrote: > On Thu, Nov 27, 2008 at 5:21 AM, Yuri Tikhonov <yur@emcraft.com>
	wrote: > > Use resource_size_t for physical address of SystemACE > > chip.
	This fixes the driver brokeness for 32 bit systems > > with 64 bit resources
	(e.g. PPC440SPe). > > Hey Yuri, > > I actually already picked up the last
	version of your patch after > fixing it up myself. It's currently sitting
	in Paul's powerpc tree > and it will be merged into mainline when Linus gets
	back from > vacation. [...] 
	Content analysis details:   (-3.7 points, 2.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.7 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hello Grant,

On Thursday 27 November 2008 17:11, Grant Likely wrote:
> On Thu, Nov 27, 2008 at 5:21 AM, Yuri Tikhonov <yur@emcraft.com> wrote:
> > Use resource_size_t for physical address of SystemACE
> > chip. This fixes the driver brokeness for 32 bit systems
> > with 64 bit resources (e.g. PPC440SPe).
> 
> Hey Yuri,
> 
> I actually already picked up the last version of your patch after
> fixing it up myself.  It's currently sitting in Paul's powerpc tree
> and it will be merged into mainline when Linus gets back from
> vacation.

 Oops. Indeed. Thanks.

> 
> Can you please spin a new version with just the addition of the
> compatible value and base it on Paul's tree.

 Sure. I've generated the patch against the origin/merge branch of Paul's 
tree, and posting it as separate "[PATCH] xsysace: add compatible string
".

 Regards, Yuri
