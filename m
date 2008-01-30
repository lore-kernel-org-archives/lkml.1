Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbYA3QvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbYA3QvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYA3Qu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:50:56 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:30421 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYA3Quy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PhfwAjlUWuBfrH+tW0KWWv4I8vaj7OrbnL1qMdM+dic2fL+zdwKjG0RlACbiIJu+T845pE+PMOTA/7zRThBK/xTTWIIOymz7ddn5F0+VdgPfuj3u8S8STmgckt5zCqBJm58gSBEmHis3gVpmuOdOhxHDpQdNyxO52LLNbMWjL0w=
Message-ID: <e2e108260801300850o199f336fiaa55b80bfb7d5d12@mail.gmail.com>
Date: Wed, 30 Jan 2008 17:50:52 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1201710871.3292.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <1201710871.3292.22.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 5:34 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2008-01-30 at 09:38 +0100, Bart Van Assche wrote:
> > On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > >
> > > iSER has parameters to limit the maximum size of RDMA (it needs to
> > > repeat RDMA with a poor configuration)?
> >
> > Please specify which parameters you are referring to. As you know I
> > had already repeated my tests with ridiculously high values for the
> > following iSER parameters: FirstBurstLength, MaxBurstLength and
> > MaxRecvDataSegmentLength (16 MB, which is more than the 1 MB block
> > size specified to dd).
>
> the 1Mb block size is a bit of a red herring.  Unless you've
> specifically increased the max_sector_size and are using an sg_chain
> converted driver, on x86 the maximum possible transfer accumulation is
> 0.5MB.

I did not publish the results, but I have also done tests with other
block sizes. The other sizes I tested were between 0.1MB and 10MB. The
performance difference for these other sizes compared to a block size
of 1MB was small (smaller than the variance between individual tests
results).

Bart.
