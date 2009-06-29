Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbZF2Ow1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbZF2Ow1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZF2OwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:52:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:26262 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZF2OwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:52:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="159613640"
Date: Mon, 29 Jun 2009 22:51:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ronald Moesbergen <intercommit@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090629145147.GA29433@localhost>
References: <20090620035504.GA19516@localhost> <4A3CD62B.1020407@vlnb.net> <20090629093423.GB1315@localhost> <a0272b440906290326rcd63849j2513f6ee9b9bf93e@mail.gmail.com> <4A489DAC.7000007@vlnb.net> <20090629125434.GA8416@localhost> <4A48BBF9.6050408@vlnb.net> <20090629131326.GA23668@localhost> <20090629132841.GA26171@localhost> <a0272b440906290743n5e089241x6e755115172a4a2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0272b440906290743n5e089241x6e755115172a4a2a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 10:43:48PM +0800, Ronald Moesbergen wrote:
> 2009/6/29 Wu Fengguang <fengguang.wu@intel.com>:
> > On Mon, Jun 29, 2009 at 09:13:27PM +0800, Wu Fengguang wrote:
> >> On Mon, Jun 29, 2009 at 09:04:57PM +0800, Vladislav Bolkhovitin wrote:
> >> > Wu Fengguang, on 06/29/2009 04:54 PM wrote:
> >> > >
> >> > > Why not 2.6.30? :)
> >> >
> >> > We started with 2.6.29, so why not complete with it (to save additional
> >> > Ronald's effort to move on 2.6.30)?
> >>
> >> OK, that's fair enough.
> >
> > btw, I backported the 2.6.31 context readahead patches to 2.6.29, just
> > in case it will help the SCST performance.
> >
> > Ronald, if you run context readahead, please make sure that the server
> > side readahead size is bigger than the client side readahead size.
> 
> I tried this patch on a vanilla kernel and no other patches applied,
> but it does not seem to help. The iSCSI throughput does not go above
> 60MB/s. (1GB in 17 seconds). I have tried several readahead settings
> from 128KB up to 4MB and kept the server readahead at twice the client
> readahead, but it never comes above 60MB/s. This is using SCST on the

OK, thanks for the tests anyway!

> serverside and openiscsi on the client. I get much better throughput
> (90 MB/s) when using the patches supplied with SCST, together with the

What do you mean by "patches supplied with SCST"?

> blk_run_backing_dev readahead patch.

Thanks,
Fengguang
