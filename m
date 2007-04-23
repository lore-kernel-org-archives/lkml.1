Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbXDWIL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbXDWIL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXDWIL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:11:56 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:3213 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXDWILy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q5YW1+lTaS3U6HyPBfggsFzsiR2G9YjRIkfDxkjMBsTdoSnBQE+dMH4hE3c2XWquXZxSSiFNfmQgcW7yhdtWV3vUTV6T5OiZuQzE8SyVdmf28I/20xpkCAYBuZoNAsOwLXHzzDT4PCAHvt/JQVhd65P0WfoOyise1ASFJ1PhpLM=
Message-ID: <653402b90704230111p50b72586te73c1288f12a0079@mail.gmail.com>
Date: Mon, 23 Apr 2007 10:11:52 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [BUG? -rc7] SMP: Just one CPU activated: P4 3GHz HT
Cc: linux-kernel@vger.kernel.org, "oliver pinter" <oliver.pntr@gmail.com>,
       "Robert Hancock" <hancockr@shaw.ca>
In-Reply-To: <462BF4DF.7080401@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.2kDN6AWFnkWM37pP5//wKJmbvRQ@ifi.uio.no>
	 <462BF4DF.7080401@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Probably the two siblings are enumerated only in ACPI tables. If you
> disable ACPI the kernel won't be aware of the second "core".
>
> Luca
> --
> "Su cio` di cui non si puo` parlare e` bene tacere".
>  Ludwig Wittgenstein
>

On 4/23/07, Robert Hancock <hancockr@shaw.ca> wrote:
>
> You didn't enable ACPI, it's needed for almost all systems to detect HT
> and also for many systems to detect multi-cores as well.
>
> Aside from that, in general I would say that on any modern x86 system
> ACPI should always be enabled. In many cases it seems the BIOS code is
> not tested much without ACPI anymore, so going without ACPI can be
> problematic.
>
> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
>

Thanks all of you. It seems the problem is ACPI, however, should not
it be noted in some way? Maybe at Documentation/smp.txt, maybe at the
help section at CONFIG_SMP, maybe a "depends on ..."

Or maybe CONFIG_SMP should enable some bits of the ACPI code needed to
detect such additional cores.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
