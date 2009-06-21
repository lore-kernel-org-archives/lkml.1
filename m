Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZFUI3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZFUI3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 04:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZFUI33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 04:29:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:23293 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZFUI32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 04:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l6oPvRR+LFvseQiLwlUFV8FVMEGVLoiq0Fyy4d00OA+XKZR8lXZOQmGOydMVZ1m973
         rPzSYCvNdLLLehEa+5e3jCrg3lVIPrEkQqvjr2yt7HCfPlbrmguCdnxVUNrqrO1mQzcr
         qmxuhd9Y75qNmompW+Nx6V994JKBAwviqSDvc=
Date: Sun, 21 Jun 2009 12:29:21 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, davem@davemloft.net,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sergey Lapin <slapin@ossfans.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 1/6] crc-itu-t: add bit-reversed calculation
Message-ID: <20090621082921.GA12749@doriath.ww600.siemens.net>
References: <1244021629-18409-1-git-send-email-dbaryshkov@gmail.com> <1244021629-18409-2-git-send-email-dbaryshkov@gmail.com> <1244033004.21215.4.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244033004.21215.4.camel@deadeye>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Jun 03, 2009 at 01:43:24PM +0100, Ben Hutchings wrote:
> On Wed, 2009-06-03 at 13:33 +0400, Dmitry Eremin-Solenikov wrote:
> [...] 
> > +/**
> > + * crc_itu_t_bitreversed - Compute the CRC-ITU-T for the data buffer;
> > + * the buffer content is assumed to be bit-reversed
> [...]
> 
> This short description spills onto two lines which is invalid and breaks
> the generation of docs.  Sorry to point this out after recommending the
> patch to you.
> 
> I've changed the description to "crc_itu_t_bitreversed - Compute the
> CRC-ITU-T for a bit-reversed data buffer" all on one line.

Just another not w.r.t. this patch: one should add 'select BITREVERSE'
to this Kconfig entry, as it depends on bitreversing stuff.

-- 
With best wishes
Dmitry

