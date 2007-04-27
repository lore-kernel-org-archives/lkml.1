Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbXD0MAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbXD0MAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbXD0MAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:00:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:55273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbXD0L76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cN2m0cKMVi5PYgQsMMxr8FZmEwUedT1ujp4hFp66JXaNtXPQ69QP2DOco2QOBbK1v3pzweEuO9noH3zm4ILOYIzFjEpRpysU52R4FTcz8GXpIJ5XZ0tEMw5gksnow1Gn8baXh7zhQKS19y0kG6wdLcqXI7gsicsXnS41DfLZzdI=
Message-ID: <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
Date: Fri, 27 Apr 2007 15:59:56 +0400
From: "Marat Buharov" <marat.buharov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Cc: "Mike Galbraith" <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <20070427013350.d0d7ac38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Aside: why the heck do applications think that their data is so important
> that they need to fsync it all the time.  I used to run a kernel on my
> laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> pleasurable.

So, if having fake fsync() and fdatasync() is pleasurable for laptop
and desktop, may be it's time to add option into Kconfig which
disables normal fsync behaviour in favor of robust desktop?
