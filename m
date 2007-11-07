Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbXKGRuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbXKGRuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXKGRt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:49:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:1404 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbXKGRt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:49:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uTOxXC6ZC1mI/Cp/9xXldL3ORba4vwCRvzPEBOIdLCf9lWHqsvT4jA4Z6CeNSDea7BdanrsMV3Q0tweeprJ3DWrwcBj9+drMBtETKb0cgRcKLaOnqacVJZCRyWijYEZJ6gzfi7ufLnM2bksCP9qahsF6kXpnuLJaHkY1rqXH5xc=
Message-ID: <86802c440711070949pc09d49ar36d0b9f32a506e20@mail.gmail.com>
Date: Wed, 7 Nov 2007 09:49:55 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pxeboot broken by commit "x86 setup: handle boot loaders which set up the stack incorrectly"
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200711070708.lA778VtP029664@terminus.zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711070708.lA778VtP029664@terminus.zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2007 11:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ah, right - this was a longstanding bug in syslinux which was fixed in 3.50-pre7.  The workaround for abug in old LILO exposed a bug in old syslinux.  Joy.
>
> --
> Sent from my cellphone (pardon any lack of formatting)
>
>
> -----Original Message-----
> From: Yinghai Lu <yhlu.kernel@gmail.com>
> Sent: Tuesday, November 06, 2007 20:12
> To: H. Peter Anvin <hpa@zytor.com>
> Subject: Re: pxeboot broken by commit "x86 setup: handle boot loaders which set up the stack incorrectly"
>
>
> On Nov 6, 2007 6:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Could you check if 3.52 is affected as well?
> >
> > --
> 3.52 works
>
> YH
>
>

good to know. everyone need to update to 3.52 now...
but i still can not understand why that mcp55 system works but the
ck804 based doesn't on 3.10

YH
