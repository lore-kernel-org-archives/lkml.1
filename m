Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZHZGJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZHZGJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbZHZGJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:09:47 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:51392 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbZHZGJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a2j5aA+cWEb8r7S9puindXDkiqlKuly++2QfFXHuAZ3d3Q35WtBF9mrKVweGY3dA6s
         H+57JyA1iy+FdbbKyPo8gL1SV/A7Md/N1N+WncUMhxbuGywQqk/Tmd0KzBS2XSnBNs/2
         zTGvq9qPbetLB6e1dwYsi9MtEAr0yCSeSQOOE=
MIME-Version: 1.0
In-Reply-To: <_yaHeGjHEzG.A.FIH.7sGlKB@chimera>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	 <_yaHeGjHEzG.A.FIH.7sGlKB@chimera>
Date: Wed, 26 Aug 2009 09:09:44 +0300
X-Google-Sender-Auth: 8d9d0cc9b44b82d1
Message-ID: <84144f020908252309u5cff8afdh2214577ca4db9b5d@mail.gmail.com>
Subject: Re: [Bug #14016] mm/ipw2200 regression
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 11:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14016
> Subject         : mm/ipw2200 regression
> Submitter       : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date            : 2009-08-15 16:56 (11 days old)
> References      : http://marc.info/?l=linux-kernel&m=125036437221408&w=4

If am reading the page allocator dump correctly, there's plenty of
pages left but we're unable to satisfy an order 6 allocation. There's
no slab allocator involved so the page allocator changes that went
into 2.6.31 seem likely. Mel, ideas?

Bartlomiej, can we see your .config, please?

                                 Pekka
