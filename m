Return-Path: <linux-kernel-owner+w=401wt.eu-S1762651AbYBHLnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651AbYBHLnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYBHLnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:43:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:47922 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYBHLnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=r4mKIaklsSM+Ly7C33Ut4v/jgooytR5x6K4sts7L2CMrRwn0/uW2nOT0BWrwFqjVlsmVYpXhH2HCg9ZDHW1WpLVJfS3Yi6bBm3diJ+pH1Uq4NuCO1qm4VeG02LdbqfZHQ5hl2BgJL+HjPMCsM/r9nvmgXhda3wMi7mRUEeNbGxw=
Message-ID: <84144f020802080343i3d9d614cjaeb51fc50f87a574@mail.gmail.com>
Date: Fri, 8 Feb 2008 13:43:03 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080208121550.GG4745@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <20080208115542.GD4745@one.firstfloor.org>
	 <84144f020802080337h5179210era890cf9b4e19c35@mail.gmail.com>
	 <20080208121550.GG4745@one.firstfloor.org>
X-Google-Sender-Auth: d43f1b90c6bbb31e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2008 2:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > need to worry about it just yet. In case it's from kmalloc() you can
> > pass __GFP_NOTRACK to annotate those call sites where the memory is
>
> Ok you should add that then to skbuff.c.

Indeed. If you look at the second patch, I think Ingo is already doing
that with __GFP_ZERO which accomplishes the same thing. But yeah,
we're probably missing a lot of callsites atm.
