Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbXHCHJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbXHCHJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbXHCHJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:09:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:12097 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbXHCHJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G5Ut8uWKgTaCXQpbl8fwI55bGp/qajiDBBf0XFV/YNVILzfdChcTxUtnmCWn2xhtEVUy1PH5Eh/+PCiFvb7kRfDLoUrbQTIpLwEUrUR/oglM3qHUPP9OXaLA7r5uNAm+nZYat3aE1Hnk3ms9qFU29IRnGCiOHdbonrzd4LIgE18=
Message-ID: <a8e1da0708030009n1209b0b3o823c5254ef57a0d0@mail.gmail.com>
Date: Fri, 3 Aug 2007 07:09:29 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Subject: Re: eurotechwdt will cause reboot
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070803062436.GA2652@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com>
	 <20070801055845.GA2648@infomag.infomag.iguana.be>
	 <a8e1da0707312322g4559a546xc357505b591f9e65@mail.gmail.com>
	 <a8e1da0708021853y1eab0ee1v859ffdb9b35762a2@mail.gmail.com>
	 <20070803062436.GA2652@infomag.infomag.iguana.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/3/07, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Dave,
>
> > Hi,
> > News: 2.6.23-rc1-mm1 will reboot with eurotechwdt, but 2.6.23-rc1-mm2
> > will not. do you need the config files?
> >
> > I will concentrate on this problem as well. Any hints how to debug?
>
> Yes: make a diff file between the two versions and see what has changed.
> If something changed on the eurotechwdt file then that is probably the
> answer you are looking for.  Else it will mean that your problem is fixed
> by other code and then we will have to find out which code did this.
>
> I was reading the datasheet to see how the driver worked. But I think
> we want to concentrate now first on what the difference is between the
> -mm1 and -mm2. Luckily something fixed allready your problem. Now it would
> be usefull to know what that was.
>
> Are your config files for both versions almost the same?
>
Yes, I just copyed the -mm1 config file to -mm2, then make oldconfig &
make. I think they are mostly same.
