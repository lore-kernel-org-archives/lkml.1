Return-Path: <linux-kernel-owner+w=401wt.eu-S1161178AbXCNMGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161178AbXCNMGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161180AbXCNMGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:06:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:31718 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161178AbXCNMGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lilEnSXhzt3CxnINXGP7bdXsLr7i6sCbBJudAqu93XnGj7/Ul8QPxJJO4B7fzBcmS/TgrM9JIfEfKoOIGnd6y950W3IBYGtclJAgKLvEm+s12PA6vkxZBMB7dJjf+lJe/rk6WuoKh3Xw2+va0FuytbMcRgk16+vuf3xAxkk8NYc=
Message-ID: <84144f020703140505g5ad5a821lf44faa84749234f0@mail.gmail.com>
Date: Wed, 14 Mar 2007 14:05:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: kernel BUG at mm/slab.c:610
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY103-DAV1644D38E44649CAF3A2C74B2730@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY103-DAV1644D38E44649CAF3A2C74B2730@phx.gbl>
X-Google-Sender-Auth: 372adf3c977dd927
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> Only to tell you, that on the console linux was printing
> this message:
>
> atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying
> access hardware directly.

Probably unrelated. CONFIG_SLAB_DEBUG should tell us what's corrupting the slab.
