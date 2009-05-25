Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZEYIQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZEYIQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZEYIPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:15:45 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:48050 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZEYIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hB7BsnDJrBOgElRehhJ1Q39BOjZKBWlRYew+F5N+pqpCiVdnrAu1aAfKGD6tzJIwAb
         uY5adsXTVE0q/dOFLFo3qhCbQIqvzwf0U+x1MMqxigkaAm5LbnbG3Fxw0hbathgA2m37
         bm86fUvZkWNoWb3TTj5wGJ8Xd86dEVZ+87+/8=
MIME-Version: 1.0
In-Reply-To: <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
	 <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
Date: Mon, 25 May 2009 11:15:42 +0300
X-Google-Sender-Auth: 65f8252e3c7bc85f
Message-ID: <84144f020905250115m1dffb51er51f8f339ab58a704@mail.gmail.com>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense 
	buffer
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 10:30 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> Fold the sense buffer into the command, thereby eliminating a slab
> allocation and free per command.
>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Interesting. I wonder how this affects the SLAB vs. SLUB regression
people are seeing on high end machines in OLTP benchmarks.

                                      Pekka
