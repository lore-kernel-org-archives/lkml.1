Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZFKSkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZFKSkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZFKSkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:40:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:37063 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZFKSkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cTsj4hcCersj2v7ESqr3NMOc0v0WL3hOk71WqFmTh/g2myXVECXdW67kGeTcyRi2rs
         4i1xGrypQTFRuvaEiHW+COSXHNYqV6YEMWvL2DyBdxc4hJHZJRgz1VCuTr6CExq6m2JZ
         i7jNOcnR09Ux+rDNpyubFaY6u10oAgZUulhIw=
MIME-Version: 1.0
In-Reply-To: <20090611183356.GH19203@electro-mechanical.com>
References: <20090609195100.GY19203@electro-mechanical.com>
	 <b6c5339f0906091339j3784c36bxe888af16272fbcde@mail.gmail.com>
	 <20090610112357.GB19203@electro-mechanical.com>
	 <20090610113406.GE19635@hash.localnet>
	 <20090610115432.GC19203@electro-mechanical.com>
	 <20090610120736.GF19635@hash.localnet>
	 <20090611152502.GG19203@electro-mechanical.com>
	 <b6c5339f0906111041u2cc55324w7b5c2523abbe2def@mail.gmail.com>
	 <20090611183356.GH19203@electro-mechanical.com>
Date: Thu, 11 Jun 2009 14:40:07 -0400
X-Google-Sender-Auth: 1dea2e4987b5c149
Message-ID: <b6c5339f0906111140l3557a545nc6a2949e8bd33f70@mail.gmail.com>
Subject: Re: [ath5k-devel] 3com 3crxjk10075 with ath5k driver
From: Bob Copeland <me@bobcopeland.com>
To: William Thompson <wt@electro-mechanical.com>
Cc: ath5k-devel <ath5k-devel@venema.h4ckr.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 2:33 PM, William
Thompson<wt@electro-mechanical.com> wrote:
>
> Isn't there an easy way to obtain the patch?  THe clone has completed but I
> don't have a clue what to do.

Just build the kernel from the resulting tree, it already has the changes
included.

As I said, the patch won't do any good because it needs the new rfkill
infrastructure.  That is why I also suggested compat-wireless which is just
the wireless code that you can build like out-of-tree modules, but it contains
all the infrastructure (http://linuxwireless.org/download/compat-wireless-2.6/).

-- 
Bob Copeland %% www.bobcopeland.com
