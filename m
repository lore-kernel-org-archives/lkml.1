Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZFTGGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZFTGGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 02:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZFTGGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 02:06:12 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:47548 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZFTGGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 02:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tv20y8nhzX9T4aHkPiBzbzv6CcNTCkQUuGQCNPko8xnaX/Pka+NaxUVUQ51K23fT43
         VQtH0BFfWtt5imvd5luNPtpzed2gLNz83mIDaNBJvRZx9R/jULx2IcOFL707OGlrIMTC
         IVYOHSmqbhH+cvkYhqjZMKuIZiz9u1cukf9G8=
Date: Fri, 19 Jun 2009 23:06:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tero Saarni <tero.saarni@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: input tree build warnings
Message-ID: <20090620060559.GA7710@dtor-d630.eng.vmware.com>
References: <20090612170536.109df1d8.sfr@canb.auug.org.au> <1244843690.3224.10.camel@hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244843690.3224.10.camel@hp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 12:54:50AM +0300, Tero Saarni wrote:
> On Fri, 2009-06-12 at 17:05 +1000, Stephen Rothwell wrote:
> > Hi Dmitry,
> > 
> > Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> > 
> > drivers/input/evdev.c: In function 'evdev_do_ioctl':
> > drivers/input/evdev.c:632: warning: comparison of distinct pointer types lacks a cast
> > drivers/input/evdev.c:660: warning: comparison of distinct pointer types lacks a cast
> > 
> > Introduced by commit 61c7bfcdf5acee06f58b246d6615989134719d19 ("Input:
> > synaptics - add support for reporting x/y resolution").
> 
> My mistake, thanks for the heads up!
> 
> 
> Input: fix warning: comparison of distinct pointer types
> 

I folded it into the original patch.

Thanks.

-- 
Dmitry
