Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYGCTis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYGCTis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYGCTij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:38:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:62831 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYGCTii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QUfypZb155cSIRcw5ZZvioKWIOLdepRTnLgyF3gUb8m1TvvpEwtV8zOvnKHKzbOMPa
         vCAuINptf+vuEGFtiqyJP2q/lV1soYMj0oxMbEBJCqHvKiA9D9WreF+KhXaKwP8Jbrxl
         nXOw1dGiMQw/dSl5EN1JUt9Jmfn1win2KBtXc=
Message-ID: <84144f020807031238p1063d2cbr3c939f5a663f83df@mail.gmail.com>
Date: Thu, 3 Jul 2008 22:38:37 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rabin Vincent" <rabin@rab.in>
Subject: Re: [PATCH] slab: rename slab_destroy_objs
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20080703191032.GA24878@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080703191032.GA24878@debian>
X-Google-Sender-Auth: 9d04a9a3b3b5b774
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Thu, Jul 3, 2008 at 10:10 PM, Rabin Vincent <rabin@rab.in> wrote:
> With the removal of destructors, slab_destroy_objs no longer actually
> destroys any objects, making the kernel doc incorrect and the function
> name misleading.
>
> In keeping with the other debug functions, rename it to
> slab_destroy_debugcheck and drop the kernel doc.
>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Applied, thanks!
