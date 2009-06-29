Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZF2Ofj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZF2Ofj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZF2Of3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:35:29 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35267 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZF2Of3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AzGFAZh5f7UU2brhxGRMaJ+lNRizNDqXiwHC6tz+x8GLlz91C2ghcX2E6D9szw7wpi
         BQzy8Nf+yNNykaTnJlZAN/kn5OP903ZryHAcDrWzQCrLOTcg4mp22RIYCELpFhacY/Uu
         eW7l/klZnDaOCin7BBs1+rqGmQzf8SU/ifYR8=
MIME-Version: 1.0
In-Reply-To: <1246286036.21450.35.camel@pc1117.cambridge.arm.com>
References: <20090626171933.GA23170@redhat.com>
	 <tnxy6rbv0oq.fsf@pc1117.cambridge.arm.com>
	 <84144f020906290248w474ad2ffpe6a8b5bede3d2c20@mail.gmail.com>
	 <1246286036.21450.35.camel@pc1117.cambridge.arm.com>
Date: Mon, 29 Jun 2009 17:35:31 +0300
X-Google-Sender-Auth: 8933ea8358432b4b
Message-ID: <84144f020906290735p3f50e25bv5626b514ba7844fb@mail.gmail.com>
Subject: Re: kmemleak reports firmware loader funnies in iwlwifi
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Mon, Jun 29, 2009 at 5:33 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> I tried to do this but it has some other implications. If I add the vmap
> hook, I would need to add vunmap as well. On ARM, at least, iounmap
> calls vunmap (but not vmap) which means that I would need to add ioremap
> support as well. That's not a bug issue but this is more like a new
> feature than a bug fix.
>
> I propose that for now I disable the kmemleak warning for unknown
> pointers and add a patch to linux-next which tracks ioremap and vmap
> mappings. Does this sound fine?

Yup, makes sense.
