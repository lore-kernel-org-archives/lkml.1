Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZCBXZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZCBXZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZCBXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:25:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:28464 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZCBXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:25:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YY0Pt6QLmrMkPYpLQEu3ZENYa7A8EXBL/a30bo8UPWZs2uyVNBCP/QlBM00iiXumY/
         omg4tpJ1R/pkBMWLRrIGQ8jOoLqXVWmivViO/OL7iDP9W1H/83nsOmxuSGXP39ITACrL
         oWUiHuyjRtrKJfEwkw9QJe+GtHm8KFw9KTEF8=
MIME-Version: 1.0
In-Reply-To: <49A53FF5.1020509@gmail.com>
References: <49A53FF5.1020509@gmail.com>
Date: Mon, 2 Mar 2009 16:25:22 -0700
X-Google-Sender-Auth: 1461165c9513f24a
Message-ID: <e9c3a7c20903021525jff8e2d4qf848a92dced8be93@mail.gmail.com>
Subject: Re: [PATCH] iop-adma, dmaengine: misplaced curly brackets?
From: Dan Williams <dan.j.williams@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 5:56 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> I observed this by code inspection, and it was not tested in any way,
> but aren't the curly brackets below wrong?
>
> please review.
> ------------------------------>8-------------8<---------------------------------
> Misplaced curly brackets.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---

Yes, static analysis caught this error here recently as well.  I have
applied your patch with a fixed up changelog:

commit d2076514c9ea68e7fef21158c1cdb8b244bfe5f2
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Wed Feb 25 13:56:21 2009 +0100

    iop-adma, mv_xor: fix mem leak on self-test setup failure

    iop_adma_zero_sum_self_test has the brackets in the wrong place for the
    setup failure deallocation path.  This error was duplicated in
    mv_xor_xor_self_test.

    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thanks,
Dan
