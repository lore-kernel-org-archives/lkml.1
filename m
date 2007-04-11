Return-Path: <linux-kernel-owner+w=401wt.eu-S1161206AbXDKF3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161206AbXDKF3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161209AbXDKF3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:29:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:35478 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161206AbXDKF3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Qj42oduZ7P/I4ZXcFlaX47NkcD7WL44EelksTxkMI45JsrnC0qqK1GEJaIxU7AWfNnNUHDIrm20EYqG/pMyXp7kVrmVxeDuQCbCOL/CRs4QWDgUrJjl89TDlhDdIu+auIO6Utf8MYSOciOx2ouxdbW6eAqijCA3HItQ4mfsdr1g=
Message-ID: <84144f020704102229i648bcd39xd579fa63a6e1c62f@mail.gmail.com>
Date: Wed, 11 Apr 2007 08:29:08 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: PATCH 7/8] lguest: the block driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Andi Kleen" <ak@muc.de>, jens.axboe@oracle.com
In-Reply-To: <1176264024.26372.93.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176203068.26372.21.camel@localhost.localdomain>
	 <1176203176.26372.25.camel@localhost.localdomain>
	 <1176203231.26372.27.camel@localhost.localdomain>
	 <1176203285.26372.29.camel@localhost.localdomain>
	 <1176203333.26372.31.camel@localhost.localdomain>
	 <1176203475.26372.37.camel@localhost.localdomain>
	 <1176203528.26372.40.camel@localhost.localdomain>
	 <84144f020704100428r6e35e34cued8758c94728a6a0@mail.gmail.com>
	 <84144f020704100436y3405f104x8345c72556d961e9@mail.gmail.com>
	 <1176264024.26372.93.camel@localhost.localdomain>
X-Google-Sender-Auth: e5c13b9f8988043d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> What a question!  end_request() doesn't end a request!  What a crazy
> idea!

Aah, indeed, end_request() uses req->hard_cur_sectors while
end_entire_request() uses req->hard_nr_sectors which I missed.

On 4/11/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hope that clarifies!

It does. Thanks Rusty :)

                                  Pekka
