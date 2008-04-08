Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbYDHFvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbYDHFvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 01:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYDHFux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 01:50:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:38977 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYDHFux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 01:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gOhs6qklqsyhU8/7uuPo3mj/Ra3l8iPBy+2PVgszyzPFAr93UStSlKQMwGEeV/EPztpInwgcpJogupcHFUsLJqx9pwR/eUfXArOgcVKRAVKDGlLt5k2w6exW11pKXhHkAyMiIBU+VcTMHC2PzkNX9KXLWQ3agfkTWPmo3Rnp2gU=
Message-ID: <aa79d98a0804072250l304232e3h29d08febb812b5f9@mail.gmail.com>
Date: Tue, 8 Apr 2008 09:50:50 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bootmem allocator
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47FAF593.4020503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu>
	 <87iqytqwl7.fsf@basil.nowhere.org>
	 <86802c440804071445l7bef949fg5c500f0c09ae40e@mail.gmail.com>
	 <aa79d98a0804072114q300e336eoec814ad6053c934d@mail.gmail.com>
	 <47FAF593.4020503@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 8:33 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Cyrill Gorcunov wrote:
>
> >
> > I think it would be a good idea ;) Btw maybe would be better to call
> > memset on the code witch relies on "clear" memory explicitly? So we will
> > clear memory allocated *only* if we really need this.
>
>  Are there any users of bootmem which will allocate a significant amount of
> memory and don't need it zeroed?
>
>         -hpa
>

Actually, I don't know without reading the code... will take a look
today evening
(have no access to sources in my office).
