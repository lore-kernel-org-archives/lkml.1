Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbYEMPQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbYEMPQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYEMPQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:16:00 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:34472 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbYEMPP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ng3YxSf1wBIIDPZViKJjnYQwC2msWapy4YmMOPFf9mtByCcnYa4E3TCbhsTrJ2rpZ8Fmqu5azzyzypdH5FOwaR+dBsav5CCuv3sg/9hW793doZenaywrynnmMxT9F7MuKZTcsWC5Z5cJUkxw6wUOko6MLi7LGcaRcJDuecSRBh8=
Message-ID: <8bd0f97a0805130815q2ffa1d34ue87f5eb1422b6f42@mail.gmail.com>
Date: Tue, 13 May 2008 11:15:57 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH 1/1] [MTD/MAPS] Blackfin Async Flash Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Cc: linux-mtd@lists.infradead.org, "Bryan Wu" <cooloney@kernel.org>,
       dwmw2@infradead.org, will.newton@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080513150143.GA18026@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1210653525-19437-1-git-send-email-cooloney@kernel.org>
	 <20080513080727.GA15795@logfs.org>
	 <8bd0f97a0805130542x46f5e7fejf1347f1c71f567fb@mail.gmail.com>
	 <20080513150143.GA18026@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:01 AM, Jörn Engel wrote:
> On Tue, 13 May 2008 08:42:08 -0400, Mike Frysinger wrote:
>  > On Tue, May 13, 2008 at 4:07 AM, Jörn Engel wrote:
>  > > On Tue, 13 May 2008 12:38:45 +0800, Bryan Wu wrote:
>  > >  >
>  > >  > +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
>  > >
>  > >  Is this still needed?
>  >
>  > yes
>
>  Can you elaborate a bit?

it's still used, therefore the definition cannot be dropped.  just
look at the probe function.
-mike
