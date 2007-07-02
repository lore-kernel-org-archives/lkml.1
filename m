Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbXGBIyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbXGBIyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 04:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXGBIyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 04:54:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:2334 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbXGBIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 04:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=azVkbCeHbSV54MK0G70eyfLXxa7mJROAbYeVcxLz5Aq1VkaFSZiBDya3AyQCwDxp6P8cCqD8uwrZ65iNP+jEwL8rlGAybk88q5WuIBe9sVVqJ935wyMCQ2pOGEg9gdw43Q5AFuXM7YqecEyQ6l1xi3vqV2HEWc3/qJnBMdmYito=
Message-ID: <863e9df20707020154o5232e44ch37dd55811c377a8f@mail.gmail.com>
Date: Mon, 2 Jul 2007 14:24:44 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: instrumentation and kprobes really still "EXPERIMENTAL"?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       systemtap@sources.redhat.com
In-Reply-To: <Pine.LNX.4.64.0707011204580.32355@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707011204580.32355@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> isn't kprobes mature enough to not be considered experimental anymore?

That would vary from arch to arch.

>   in addition, while most of the KPROBES config options depend on
>
>   KALLSYMS && EXPERIMENTAL && MODULES
>
> the s390 architecture depends only on
>
>   EXPERIMENTAL && MODULES
>
> and its instrumentation support is *not* listed as experimental.
>
>   also, the avr32 entry is in the file Kconfig.debug, and depends only
> on DEBUG_KERNEL.  just an observation.

This probably stems from the episodic growth kprobes across different
archs. It can be cleaned up I suppose.

--
Abhishek Sagar

P.S: Adding systemtap in CC.
-
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
