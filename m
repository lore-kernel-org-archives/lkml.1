Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbXBPOI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbXBPOI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbXBPOI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:08:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:13319 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbXBPOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tV35hnBtglY0utOulOpES7Dkaiq3MsTW3hGgbSMi6MbcJaVS5c490J2Sg4xUodKDdhhyeAmVNi1kNFOXDDEdDrhNttwmq2PAjzCVGU8nwpa27WPuKUvXOeFtTDp9GbzxhvDEV/uAHHjfDLjysWq/yJ3Qf8rCRT9sLB5AKEwT52o=
Message-ID: <82ecf08e0702160608q3fbf1a68t16933b32e5db16ff@mail.gmail.com>
Date: Fri, 16 Feb 2007 12:08:53 -0200
From: "Thiago Galesi" <thiagogalesi@gmail.com>
To: "Heikki Orsila" <shdl@zakalwe.fi>
Subject: Re: [RFC] New driver information
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070216135851.GA7939@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070216135851.GA7939@zakalwe.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SInce this information does not, in any way, affect the functioning of
the driver... It is not "executable code", I don't see the point of
it.

For "module_licence" we have the restriction of some functions being
used only for GPL code, but for this?!? I really don't see it...

Just think: what would this macro do, "executable-code wise"?


On 2/16/07, Heikki Orsila <shdl@zakalwe.fi> wrote:
> I just read
>
>         http://kerneltrap.org/node/7729
>
> and it occured to me that it would be informative to have a new device
> driver macro. The motivation for the new macro would be 4 issues:
>
>         * Is it possible to get specifications for the device?
>         * If yes, under what terms? (nda, public)
>         * Where to get public specs?
>         * How many closed and open drivers in the Linux source tree?
>
> I suggest to add following macro:
>
> MODULE_SPECIFICATION(terms, source);
>
> where "terms" is one of
>
>  * MODULE_SPEC_ANY_PARTY_NDA
>         - specification available to any party for an NDA
>  * MODULE_SPEC_ANY_PARTY
>         - specification available in public, or at least available
>           without NDA to any party
>  * MODULE_SPEC_RESTRICTED
>         - none of the above
>
> and "source":
>
>  * contact address for nda specs
>  * any public source for a public specification (http://, email address,
>    ...)
>  * empty string otherwise
>
> I realise this macro somewhat circumvents the purpose of Documentation/
> directory but the idea is to have a direct 1:1 mapping between drivers
> and specification sources so that it would be easy to collect statistics
> of "open" hardware by using grep et al.
>
> What do you think? Useless annotations or useful information?
>
> --
> Heikki Orsila                   Barbie's law:
> heikki.orsila@iki.fi            "Math is hard, let's go shopping!"
> http://www.iki.fi/shd
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
-
Thiago Galesi
