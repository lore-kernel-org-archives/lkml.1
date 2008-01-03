Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYACTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYACTDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYACTDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:03:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:47309 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYACTDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:03:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sHgp+Q70H4FEOn4FMmptDM2iCNhs/RVAy9Y/q+KdsVKyWdZVxskt84x5/2aj0XAqvS/rQkh6XegY/HWPijXQ4WTafH3HiLP8fRMQB0pIbuYn0NLcryYQfrILC1/MKal5p2Xisnj4CzuXN2/lP6sXBqQuP+csyVZvRXHQf3cQayo=
Message-ID: <29495f1d0801031103v6c1d76a8meabeab61d0cda2a7@mail.gmail.com>
Date: Thu, 3 Jan 2008 11:03:35 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [6/8] GBPAGES: Add an option to disable direct mapping gbpages and a global variable
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080103172703.100C014DDD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103626.635376000@suse.de>
	 <20080103172703.100C014DDD@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/08, Andi Kleen <ak@suse.de> wrote:
>
> Signed-off-by: Andi Kleen <ak@suse.de>

<snip>

> Index: linux/Documentation/x86_64/boot-options.txt
> ===================================================================
> --- linux.orig/Documentation/x86_64/boot-options.txt
> +++ linux/Documentation/x86_64/boot-options.txt
> @@ -307,3 +307,6 @@ Debugging
>                         stuck (default)
>
>  Miscellaneous
> +
> +       direct_gbpages=off
> +               Do not use GB pages for kernel direct mapping.

Sorry if this is a FAQ, but why do we have this file in addition to
kernel-parameters.txt? I see that kernel-parameters.txt refers to this
file, so I guess it's ok, but shouldn't we try to consolidate?

Thanks,
Nish
