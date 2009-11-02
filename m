Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZKBRkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZKBRkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZKBRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:40:13 -0500
Received: from mail.lang.hm ([64.81.33.126]:33203 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431AbZKBRkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:40:12 -0500
Date: Mon, 2 Nov 2009 09:39:55 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <20091102091611.60dfeea1@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.0911020936500.12321@asgard.lang.hm>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk>
 <alpine.OSX.1.10.0911012023020.55434@caridad.local> <20091102091611.60dfeea1@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Alan Cox wrote:

>> I'm certain if we made a Venn diagram, there would be an overlap. But
>> FatELF solves different problems than package managers, and in the case of
>> ia32 compatibility packages, it helps the package manager solve its
>> problems better.
>
> Not really - as I said it drives disk usage up, it drives network
> bandwidth up (which is a big issue for a distro vendor) and the package
> manager and file system exist to avoid this kind of mess being needed.

I think this depends on the particular package.

how much of the package is binary executables (which get multiplied) vs 
how much is data or scripts (which do not)

fo any individual user it will alsays be a larger download, but if you 
have to support more than one architecture (even 32 bit vs 64 bit x86) 
it may be smaller to have one fat package than to have two 'normal' 
packages.

yes, the package manager could handle this by splitting the package up 
into more pieces, with some of the pieces being arch independant, but that 
also adds complexity.

David Lang

> You can ask the same question as FatELF the other way around and it
> becomes even more obvious that it's a bad idea.
>
> Imagine you did it by name not by architecture. So you had a single
> "FatDirectory" file for /bin, /sbin and /usr/bin. It means you don't have
> to worry about people having different sets of binaries, it means they
> are always compatible. And like FatELF it's not a very good idea.
>
> Welcome to the invention of the directory.
>
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
