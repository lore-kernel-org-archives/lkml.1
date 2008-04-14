Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbYDNW2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbYDNW2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYDNW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:28:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:18287 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbYDNW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QUDgbeG7cMyKIfK/ZSpnwwi87SwBrYZCH6eiPiG3lKWv98QWmjj4zyeccQn8jSC2i4rv2GAfaGXH+DXkaP2/JfnpLldp9hhwo/qVd3/cHggrzDfr+ZJRXN7DFUmGy9rXy55Iwdsto0gUyVmQwTDjWWfz7qIc2X3n1f+Jvl+Z8eY=
Message-ID: <e9c3a7c20804141527k475ee297wdf1053179abdaaf8@mail.gmail.com>
Date: Mon, 14 Apr 2008 15:27:45 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [2.6 patch] add include/asm-avr32/xor.h
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>,
       hskinnemoen@atmel.com, herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       shannon.nelson@intel.com
In-Reply-To: <8bd0f97a0804141511o28385fcfl11923148f7fe701a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414141632.GA6695@cs181133002.pp.htv.fi>
	 <20080414181140.GA813@Chamillionaire.breakpoint.cc>
	 <20080414181536.GZ6695@cs181133002.pp.htv.fi>
	 <20080414214640.GA2282@Chamillionaire.breakpoint.cc>
	 <20080414220129.GH26885@cs181133002.pp.htv.fi>
	 <8bd0f97a0804141511o28385fcfl11923148f7fe701a@mail.gmail.com>
X-Google-Sender-Auth: dab6e4e98944dcf3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 3:11 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Apr 14, 2008 at 6:01 PM, Adrian Bunk <bunk@kernel.org> wrote:
>  > On Mon, Apr 14, 2008 at 11:46:40PM +0200, Sebastian Siewior wrote:
>
> >  > so most
>  >  > xor.h files are identical copies and this is probably as bad as a
>  >  > trailing white space :)
>  >
>  >  I'm not sure whether it's worth spending my time discussing whether
>  >  adding a config variable to 6 architectures is really better than
>  >  adding trivial headers to 3 architectures...
>
>  long term robustness for new ports/codedrops indicates that having a
>  common header in linux/ and making arches opt-in via Kconfig/whatever
>  makes life a lot easier for everyone
>
>  everything builds by default with the generic C versions and arches
>  dont have to go through and figure out all the fun little stub files
>  they need to straight copy from other architectures ... they only have
>  to care if they want to implement an optimized version

"arches" did not have to go through and figure out the fun little stub
file for xor.h.  Adrian already made your "life easier".

--
Dan
