Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbXLLPD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbXLLPD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXLLPDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:03:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:50286 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXLLPDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=grhXJOEE67DU6zN2QPW+PieUXuHYtN/dYVnMykRXiZ7Rp9lmqmcfXzqgDTuprW31N3Uc8NhGkFIzUWrTh+xZDEMAFf+QLEiOgClmiOsQ1WLQMYTWCCY2Rfl0CEAgslddYyZvZFjGikycffZNLddmnl62Bpgti42iELm0oAW2EG0=
Message-ID: <9e0cf0bf0712120657p1a8fac7aoc5a82df1ff24daac@mail.gmail.com>
Date: Wed, 12 Dec 2007 16:57:39 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Luciano Rocha" <luciano@eurotux.com>,
       "Alon Bar-Lev" <alon.barlev@gmail.com>, ldm@flatcap.org,
       ntfs-3g-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ntfs-dev@lists.sourceforge.net
Subject: Re: ldminfo compilation
In-Reply-To: <20071212145241.GA25092@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e0cf0bf0712120639r7bd5582bg63f8512164836989@mail.gmail.com>
	 <20071212145241.GA25092@bit.office.eurotux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/07, Luciano Rocha <luciano@eurotux.com> wrote:
> Those are for the kernel module setting the partition tables. If you're
> only interested in the ldminfo utility:
> make -C ldmutil CPP='g++ -static'
>
> Substitute g++ for the C++ compiler you want to use.

Hi!
Thank you for your reply!

I don't really understand how to use the output of ldmutil in order to
do the dmsetup... All the instructions are for ldminfo...

And the C++ dependency does not work well with uclibc... I tried to
compile this using uclibc++, but the exception handling of uclibc++ is
broken for some strange reason... And I don't wish to introduce the
overhead of the C++ libraries to my system...

If ldmutil contain all the information, I will backport this to C and
be happy... :)
Can you please tell me how you use the output of this utility to merge
a spanned partition on two separate disks?

Best Regards,
Alon Bar-Lev.
