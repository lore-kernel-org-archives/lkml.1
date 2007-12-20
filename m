Return-Path: <linux-kernel-owner+w=401wt.eu-S938183AbXLTPvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938183AbXLTPvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966608AbXLTPmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:42:44 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:52904 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966600AbXLTPmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:42:42 -0500
Message-ID: <fa686aa40712200742i89a2ca9p60365b06adc426c@mail.gmail.com>
Date: Thu, 20 Dec 2007 08:42:41 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] [RFC] Xilinx SystemACE: Add media hotplug support
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sr@denx.de, monstr@monstr.eu, jwilliams@itee.uq.edu.au,
       stephen.neuendorffer@xilinx.com
In-Reply-To: <20071220144532.GA27885@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220062348.16448.24575.stgit@trillian.secretlab.ca>
	 <20071220144532.GA27885@shadowen.org>
X-Google-Sender-Auth: cfd3277d9bb8dc8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/07, Andy Whitcroft <apw@shadowen.org> wrote:
> On Wed, Dec 19, 2007 at 11:23:48PM -0700, Grant Likely wrote:
>
> > +             /* Make the sysace device 'live' */
> > +             if (ace->fsm_state != ACE_FSM_STATE_INVALIDATE_MEDIA);
> > +                     add_disk(ace->gd);
>
> checkpatch.pl reports the above if as suspect due to the trailing ;.
> Looks wrong to me too.

Ah, good catch.

Thanks.
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
