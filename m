Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbYDNWL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbYDNWL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYDNWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:11:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:12865 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYDNWLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rUrn3x86Cpv7v87Cl34dpGHzWKn4Sl+w+aXCretbEaEjO4A1oDB9SJJGPBrUusbliITsxtejm/EzLjMcPtiAJ301UJEZJWuhSGlr8n3br6bP2/HWEj4XoAnM/AgMVXE+VfCU2jzGKpAn7X9KCQKbJ+AwMxhdg0VMaB06+vnGPys=
Message-ID: <8bd0f97a0804141511o28385fcfl11923148f7fe701a@mail.gmail.com>
Date: Mon, 14 Apr 2008 18:11:45 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] add include/asm-avr32/xor.h
Cc: "Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>, hskinnemoen@atmel.com,
       herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       shannon.nelson@intel.com, dan.j.williams@intel.com
In-Reply-To: <20080414220129.GH26885@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414141632.GA6695@cs181133002.pp.htv.fi>
	 <20080414181140.GA813@Chamillionaire.breakpoint.cc>
	 <20080414181536.GZ6695@cs181133002.pp.htv.fi>
	 <20080414214640.GA2282@Chamillionaire.breakpoint.cc>
	 <20080414220129.GH26885@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 6:01 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Apr 14, 2008 at 11:46:40PM +0200, Sebastian Siewior wrote:
>  > so most
>  > xor.h files are identical copies and this is probably as bad as a
>  > trailing white space :)
>
>  I'm not sure whether it's worth spending my time discussing whether
>  adding a config variable to 6 architectures is really better than
>  adding trivial headers to 3 architectures...

long term robustness for new ports/codedrops indicates that having a
common header in linux/ and making arches opt-in via Kconfig/whatever
makes life a lot easier for everyone

everything builds by default with the generic C versions and arches
dont have to go through and figure out all the fun little stub files
they need to straight copy from other architectures ... they only have
to care if they want to implement an optimized version
-mike
