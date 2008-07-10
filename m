Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYGJW7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYGJW7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 18:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbYGJW7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 18:59:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:3751 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYGJW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 18:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mFjHIfEKtm0Pll9AtBseVGBfz0F5hwMotQaK0xK3z4XkKQ8yIbPr0Lw0WNtRJAY7q7
         asXuQgJIElNOiO/QS8qB9Y1vaMYnPqdCRVoqlEt+bHEH+xUom4w33e43dXxYfgLLyy3W
         iFL7KSIA2BMIOTnxmRm4CwqSZAjAs6ZT1pNS8=
Message-ID: <646765f40807101559q51fbfc50x8e3466e5f202e0c8@mail.gmail.com>
Date: Fri, 11 Jul 2008 08:59:20 +1000
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Mikulas Patocka" <mpatocka@redhat.com>
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 07:56, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Hi
>
> I'm getting crashes with InitIO A100u2w controller on Sparc64 (I had to fix
> the endianity issues in the driver, but that's unrelated).
>
> When I examined the crashes, it turned out that SCSI layer passed requests
> with too many segments. The controller has at most 32 SG entries per
> request. It sets shost->sg_tablesize to 32, but despite this, larger
> requests were submitted to it --- this resulted in overwriting random memory
> and crashes.

[snip]

Should this have been CC'd to linux-scsi too? This sounds like it
could be a bug at their end.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
