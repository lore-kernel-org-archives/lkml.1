Return-Path: <linux-kernel-owner+w=401wt.eu-S933270AbXAaNoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbXAaNoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbXAaNoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:44:19 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:31371 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbXAaNoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:44:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sbOClvccRjW3ECiPqKaUPP52Kxz/I/YAiN0GFsHngjyTS8euyKpCsOQQmBs/Jg1YgVygegW7CrVxoQ+WJUe2Kvo5VpILm/F6qoNuJ8gIX3JrsVqQyvsJvBEoF4KCvbNEo35bZMxCd97AYnVZeIZUL2lG5vdSpk/zTrlwJRTMrTQ=
Message-ID: <6bffcb0e0701310544w474810cfh83fbfa539e1c0573@mail.gmail.com>
Date: Wed, 31 Jan 2007 14:44:17 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Centralize the selection for debugging semaphores.
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com, rth@twiddle.net
In-Reply-To: <Pine.LNX.4.64.0701310825500.4627@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701310825500.4627@CPE00045a9c397f-CM001225dbafb6>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/01/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
>   Centralize the kernel config option for debugging semaphores and
> modify the macro for frv to use that config option instead.
>
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
[..]
> +config DEBUG_SEMAPHORE
> +       bool "Semaphore debugging"
> +       depends on DEBUG_KERNEL
> +       default n
> +       help
> +         If you say Y here then semaphore processing will issue lots of
> +         verbose debugging messages.  If you suspect a semaphore problem or a
> +         kernel hacker asks for this option then say Y.  Otherwise say N.
> +
> +         At the moment, this is implemented only by alpha and frv.

IMHO this option should stay in arch/{alpha,frv}/Kconfig.debug

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
