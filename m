Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbXEUFjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbXEUFjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXEUFjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:39:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:33048 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXEUFjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sB1Zl9IJINXXzLBifkMZcuVuea7z0ZSGNWERmi/+4ZD2R/xach2XoxKEDMtB93BcMypSG9nxHJhbQEa1u/27SEJ3AWCge4iFIOnQ3sNW0lR0A97YU3G58FKyqiKaMJj27VwsMJjT+1P5eApgApsMXwPJRe0j5JihyVbuJ+tgj04=
Message-ID: <a8e1da0705202239r31d03a5dyc2f0ce6a795e0124@mail.gmail.com>
Date: Mon, 21 May 2007 05:39:38 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.22-rc1-mm1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46512821.9010905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com>
	 <a8e1da0705180154v37e8ec5fs2cc4de9417cd44d2@mail.gmail.com>
	 <a8e1da0705180307m60a91996r91c8bfcd1c863a94@mail.gmail.com>
	 <464DDA40.6010101@zytor.com>
	 <a8e1da0705201753i1527138ape2163817c6c0d3b5@mail.gmail.com>
	 <465124EA.1020801@zytor.com>
	 <a8e1da0705202200u5976d14do7ec1469941bb2967@mail.gmail.com>
	 <46512821.9010905@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> Could you put printf's in the setup code (especially
> arch/i386/boot/main.c) to see how far it runs before it dies?
>
>         -hpa

I add some debug info to main.c, the result is that the kernel stopped
in query_edd();

Then I use kernel argument edd=off, the kernel booted happilly.

I will read the edd.c to see what happened. do you have some suggestion?
