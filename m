Return-Path: <linux-kernel-owner+w=401wt.eu-S1762735AbYBSWFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735AbYBSWFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762081AbYBSWEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:04:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:1724 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761884AbYBSWEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=wXuJHCzur3NlJHG3N5CMs084g88raEugv7InQui8qf5dSilkDvRefTf3i8jTo0UZhPRUpVs0OfwTOmETW4pg91ls6izpTv/eGOJkScDthnqq3Dn9t6RpfQwiSaXpckU5HalrVzCyvjuhl37e5mU5xRjMOjohwam5oanaeUhIdk0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] remove include/linux/hdsmart.h
Date: Tue, 19 Feb 2008 22:51:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>, linux-kernel@vger.kernel.org
References: <200802171807.57983.bzolnier@gmail.com> <200802171904.52188.bzolnier@gmail.com> <20080219192905.GE31955@cs181133002.pp.htv.fi>
In-Reply-To: <20080219192905.GE31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192251.56634.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Adrian Bunk wrote:
> On Sun, Feb 17, 2008 at 07:04:51PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 17 February 2008, Adrian Bunk wrote:
> > 
> > > Why can't we simply remove it?
> > 
> > If it is safe w.r.t. userspace then please do it.
> > 
> > [ I don't know and I couldn't get an answer on LKML so... ]
> 
> The purpose of the kernel userapce headers is to contain the interfaces 
> between the kernel and userspace.
> 
> If nothing in the kernel uses it there's not much value in keeping it.
> 
> Removal patch below.
> 
> > Thanks,
> > Bart
> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> include/linux/hdsmart.h is not used by the kernel and should therefore 
> be removed.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
