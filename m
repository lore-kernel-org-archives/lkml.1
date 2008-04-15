Return-Path: <linux-kernel-owner+w=401wt.eu-S1765354AbYDOVUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765354AbYDOVUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763818AbYDOVUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:20:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:30258 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764648AbYDOVT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ZwL7M6S++NJkDF2XkOAEf5ueYIIggz+oUQsLjPJeeGZvZ3wOQG5K/v7O+mwgO4R8WNEixS090Ojg77GFaUTV6GtltNCv89e5pAgL7lLSmmsDSdx34XncSb1mzDTTmRsJ3aH036ZwTdT7ZFsW8Mg7tpHKE73lEO6SrhXZXWLpBFA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] remove the broken ETRAX_IDE driver
Date: Tue, 15 Apr 2008 23:35:20 +0200
User-Agent: KMail/1.9.9
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <Jesper.Nilsson@axis.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080413183629.GA21204@cs181133002.pp.htv.fi> <4BEA3FF3CAA35E408EA55C7BE2E61D050D3FB020@xmail3.se.axis.com> <20080414184213.GB6695@cs181133002.pp.htv.fi>
In-Reply-To: <20080414184213.GB6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804152335.21101.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Adrian Bunk wrote:
> On Mon, Apr 14, 2008 at 02:50:19PM +0200, Mikael Starvik wrote:
> > You can remove it for now and we will resubmit a new if/when we get around
> > to fix it.
> 
> Thanks for the confirmation.
> 
> > /Mikael
> 
> cu
> Adrian
> 
> BTW: If/When you'll get around to work on it, please consider using
>      libata instead.
> 
> 
> <--  snip  -->
> 
> 
> ETRAX_IDE was marked as broken last year with the comment
> "it doesn't even compile currently".
> 
> Remove it since it won't get fixed in the near future.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied

[ I ported the patch over IDE tree (it becomes honorable patch #250)
  so it deletes the most recent ide-cris version - even though the
  driver was marked as BROKEN I kept updating it and it is the best
  starting point if somebody would like to revive it in the future
  (or port it to libata). ]
