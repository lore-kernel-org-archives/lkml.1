Return-Path: <linux-kernel-owner+w=401wt.eu-S1161696AbXDXHqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161696AbXDXHqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161699AbXDXHqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:46:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:22031 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161696AbXDXHqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FTMT293XVUonZXzh9RRTXNy40VtyDJgW8BZwLN7Zkz8f1zHO8bp5FbWdmSs6zNa60QRZyPQB6lWJ/CDXWhk1ZzYZ2cu5XlzxDfI+xw8ggdeHoAjbVQ34e5himrpcihTFyBD+DAh9JfY101wZHPp7YOC3Wy5ho0G/wuT7RTZno/s=
Message-ID: <4ac8254d0704240046s23b2d349m2e0f0caa7eb95a91@mail.gmail.com>
Date: Tue, 24 Apr 2007 09:46:12 +0200
From: "Tuncer Ayaz" <tuncer.ayaz@gmail.com>
To: "William Heimbigner" <icxcnika@mar.tar.cc>
Subject: Re: NonExecutable Bit in 32Bit
Cc: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704240640470.25153@server.thyself>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net>
	 <Pine.LNX.4.64.0704240640470.25153@server.thyself>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> On Tue, 24 Apr 2007, Cestonaro, Thilo (external) wrote:
>
> > Hey,
> >
> > is it right, that the NX Bit is not used under i386-Arch but
> > under x86_64-Arch?
> > When yes, is there a special argument for it not to be used?
> >
> > Ciao Thilo
> I don't think so - some i386 cpus definitely have support for
> the NX bit.
>

In detail:
1) if your CPU has NX support (some 32bit Xeons do)
2) it is not disabled in the BIOS
3) you see 'nx' in the 'flags' line in /proc/cpuinfo
4) and you have a kernel with the following config options
CONFIG_HIGHMEM64G=y
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y

NX should just work.

[snip]
