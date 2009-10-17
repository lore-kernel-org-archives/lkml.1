Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZJQXR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZJQXR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 19:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZJQXR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 19:17:56 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35932 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZJQXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 19:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=Zq19TdR14Ll729Y72mJUGNAAKQuWdk5Vbol3oP0Fh6ut+F3h6QBEDjJnMrLegcelGp
         Bzpq0nXAW1EP/sZINXqgyJkFGEJRDVioDIr/mkVcouUz2jjU8uE8KtoetUMtCGdkISon
         J+icVlQY8BGEmjsOyfBA1fho88xJxRBpxUo90=
MIME-Version: 1.0
In-Reply-To: <20091016084924.GB4234@linux.vnet.ibm.com>
References: <1255557226-4403-1-git-send-email-timur@freescale.com>
	 <200910152041.26646.borntraeger@de.ibm.com>
	 <4AD770A9.6070509@freescale.com>
	 <200910152126.28024.borntraeger@de.ibm.com>
	 <4AD778E6.7020806@freescale.com>
	 <20091016084924.GB4234@linux.vnet.ibm.com>
Date: Sat, 17 Oct 2009 18:17:58 -0500
X-Google-Sender-Auth: 560eeb422a8a77eb
Message-ID: <ed82fe3e0910171617v6cdec1f9r9dc33cfb8852a31a@mail.gmail.com>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
From: Timur Tabi <timur@freescale.com>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Scott Wood <scottwood@freescale.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linuxppc-dev@ozlabs.org,
       Timur Tabi <timur@freescale.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 3:49 AM, Hendrik Brueckner
<brueckner@linux.vnet.ibm.com> wrote:

> The states are handled by the hvc_iucv itself:
> If the hvc_iucv code has a connection established, terminal or console data
> are queued and sent to the peer. If the state is disconnected, terminal and
> console data is discarded internally.

So what is the plan now?

-- 
Timur Tabi
Linux kernel developer at Freescale
