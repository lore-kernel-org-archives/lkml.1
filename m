Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbYGGQQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbYGGQQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYGGQQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:16:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:19587 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbYGGQQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u4Eo0n9n3bsKKMHIPgvGjfeq9oHjASHujr+d6734sfk4TFh2vy8aI40mFHGsDRX+ke
         rbeCzLXB9tv/RgE3LqCV7B6MOqt9vfvzb2AHX2XwpjHzjEQh934fxfAaVv3My6jH2ks7
         ++DpwdoZSKyOCUn+x2ZRIFFxBBnfpqXWJWVeU=
Message-ID: <48f7fe350807070916v4b8292aerb0a6fd0f360c5b9b@mail.gmail.com>
Date: Mon, 7 Jul 2008 12:16:25 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Hugh Dickins" <hugh@veritas.com>,
       benh@kernel.crashing.org, "Zan Lynx" <zlynx@acm.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <487239BE.8070505@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com>
	 <486E4FD8.4010102@acm.org>
	 <Pine.LNX.4.64.0807042112130.16912@blonde.site>
	 <200807071806.11630.nickpiggin@yahoo.com.au>
	 <487239BE.8070505@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you tried running Xorg 1.4.99.905?

On Mon, Jul 7, 2008 at 11:43 AM, Carsten Otte <cotte@de.ibm.com> wrote:
> Nick Piggin wrote:
>>
>> I think we need a similar fix for s390 too. If so, then it really should
>> get into 2.6.26, but this late in the release, I hope an s390 maintainer
>> might be able to test and verify the fix?
>
> I've done my best to combine mprotect, mmap and munmap a MAP_PRIVATE mapping
> on a xip file system. The system runs stable with and without this patch.
> Could someone please enlighten me on how to reproduce the problem so that I
> can verify the fix?
>
