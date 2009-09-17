Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZIQGmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZIQGmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZIQGmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:42:22 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:33092 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZIQGmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lZ6C4/IsVwjwUNP1ogMEWSds8TwCn8YTfW1+muBg+bIUdSL+sQNHCg2OtHi2CiOP1A
         JQ7i3smPQnuLPaQ6fsAd48nkHl5zVxBqKrXIdKWKtNdZxvR6RJpYIOslWR9g1g9Emyx7
         m9V0ojqnt6Cds6x3TdHv//oqrj4mGsnlnmt8k=
MIME-Version: 1.0
In-Reply-To: <20090914165435.GA21554@infradead.org>
References: <202cde0e0909132230y52b805a4i8792f2e287b01acb@mail.gmail.com>
	 <20090914165435.GA21554@infradead.org>
Date: Thu, 17 Sep 2009 18:42:20 +1200
Message-ID: <202cde0e0909162342xb2a8daeia90b33a172fc714b@mail.gmail.com>
Subject: Re: HugeTLB: Driver example
From: Alexey Korolev <akorolex@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Eric Munson <linux-mm@mgebm.net>,
       Alexey Korolev <akorolev@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> There is an example of simple driver which provides huge pages mapping
>> for user level applications. The  procedure for mapping of huge pages
>> to userspace by the driver is:
>>
>> 1. Create a hugetlb file on vfs mount of hugetlbfs (h_file)
>
> Note that to get your support code included at all you'll need a real
> intree driver, not just an example.  That is if VM people are happy with
> the general concept.
Hi,
The driver example listed here takes the same approach as already done
inside ipc/shm.c. So people can refer this file for development. The
patches just make existing functions more usable by drivers and this
example is an extract of ipc/shm.c in order to give pretty simple
how-to.
Seems I gave a not so good description for this patch set so it caused
a lot of misunderstanding, sorry about that.

Thanks,
Alexey
