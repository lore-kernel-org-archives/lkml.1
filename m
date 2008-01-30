Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYA3NLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYA3NLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYA3NKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:10:51 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:4858 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYA3NKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:10:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gzVVte+yhQf1te5sPj6ZDyNB/VeWx9VzKlj9JTBbrw1ANtFM8Jva27eemHfcziHgQ3OPAZJiBipLleTNPO7GVHR2/XnTycCi9pMIIQf5Y1lkc1rXhT+XiBFB1TQgNOofQjb70NvRuHQHWOeIJbqY/mCn03H76Kasv2xiCTl17hE=
Message-ID: <e2e108260801300510q94bf9c8g31a0ba9d77c3c0b9@mail.gmail.com>
Date: Wed, 30 Jan 2008 14:10:47 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "FUJITA Tomonori" <tomof@acm.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080130195635T.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 11:56 AM, FUJITA Tomonori <tomof@acm.org> wrote:
> On Wed, 30 Jan 2008 09:38:04 +0100
> "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
> >
> > Please specify which parameters you are referring to. As you know I
>
> Sorry, I can't say. I don't know much about iSER. But seems that Pete
> and Robin can get the better I/O performance - line speed ratio with
> STGT.

Robin Humble was using a DDR InfiniBand network, while my tests were
performed with an SDR InfiniBand network. Robin's results can't be
directly compared to my results.

Pete Wyckoff's results
(http://www.osc.edu/~pw/papers/wyckoff-iser-snapi07-talk.pdf) are hard
to interpret. I have asked Pete which of the numbers in his test can
be compared with what I measured, but Pete did not reply.

> The version of OpenIB might matters too. For example, Pete said that
> STGT reads loses about 100 MB/s for some transfer sizes for some
> transfer sizes due to the OpenIB version difference or other unclear
> reasons.
>
> http://article.gmane.org/gmane.linux.iscsi.tgt.devel/135

Pete wrote about a degradation from 600 MB/s to 500 MB/s for reads
with STGT+iSER. In my tests I measured 589 MB/s for reads (direct
I/O), which matches with the better result obtained by Pete.

Note: the InfiniBand kernel modules I used were those from the
2.6.22.9 kernel, not from the OFED distribution.

Bart.
