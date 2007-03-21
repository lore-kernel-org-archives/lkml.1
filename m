Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbXCUPo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbXCUPo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbXCUPo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:44:29 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:39405 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbXCUPo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JGbQeRzVzrQAlZ4tdMp00YRM1uphmexzrBeEjI5PSNwpgxrNF8Z7/PyEExCISeknXipiLzqNuFRP2qz5TulUs8MbgwE9qi1OC+3gaQtshlUizPgV2WUuoh1xafCmSWeXD7IBLvkylfUAFJ7Fan3tib4Sa4z9lvmTIJ5NFK8PiKo=
Message-ID: <8bd0f97a0703210844u44209fc2k27f8ccf431862557@mail.gmail.com>
Date: Wed, 21 Mar 2007 11:44:27 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Wu, Bryan" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
In-Reply-To: <20070305092346.GB11664@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172722480.5264.75.camel@roc-desktop>
	 <20070305092346.GB11664@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > +int __init oprofile_arch_init(struct oprofile_operations *ops)
> > +{
> > +#ifdef CONFIG_HARDWARE_PM
> [snip]
> > +#else
> > +     return -1;
> > +#endif
> > +}
>
> Uh.. fix your dependencies.

can you elaborate ?
-mike
