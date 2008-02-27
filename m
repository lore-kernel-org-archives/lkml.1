Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbYB0UGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbYB0UGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757801AbYB0UGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:06:12 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:11098 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbYB0UGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b/luF4AFzREk/EeXWxBhXvlV7BdbCe1yS2bpsWB74taaI4JbIRhmRmBVyc4j8I+FcQRyUt5TMnvtdP/Z840z7LhRps3awgwImF0HhIyBFVHXhG0Unei5pp+Bzy/7oKMPSiiCHC1bDUKTvF2+sdojW+oBuJ9YtJJS2/PGTGaJoLk=
Message-ID: <b1bc6a000802271206l3e99afedt64d5f7cc238365d6@mail.gmail.com>
Date: Wed, 27 Feb 2008 12:06:08 -0800
From: "adam radford" <aradford@gmail.com>
To: "Andre Noll" <maan@systemlinux.org>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Cc: "Tony Battersby" <tonyb@cybernetics.com>,
       "Arnd Hannemann" <hannemann@nets.rwth-aachen.de>,
       "=?ISO-8859-1?Q?Johannes_W=F6rner?=" 
	<johannes.woerner@tuebingen.mpg.de>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080227170528.GB29468@skl-net.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080226174314.GA30767@skl-net.de>
	 <47C49B99.1060707@nets.rwth-aachen.de>
	 <20080227101154.GD30767@skl-net.de> <47C57327.6070901@cybernetics.com>
	 <20080227170528.GB29468@skl-net.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 9:05 AM, Andre Noll <maan@systemlinux.org> wrote:
> On 09:26, Tony Battersby wrote:
>  > > Thanks, this helped a lot. However, there does not seem to be a way
>  > > to make the system more responsive, which is really the problem we
>  > > are experiencing.

Andre,

Can you try turning down /sys/block/sdX/device/queue_depth to 16 and
see if that improves your responsiveness?

-Adam
