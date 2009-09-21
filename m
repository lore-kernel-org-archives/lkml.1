Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZIUFQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZIUFQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 01:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZIUFQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 01:16:23 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:43893 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbZIUFQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 01:16:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ix+Oy00DjyJAjvqA3epkEvRNpw1t0ZuNE0gfkAJQ5KzJNxfxpfZF85e+DDxZeiW57k
         6nI5rLW4mhFpfra9jgSElSfTnP4nLg38GvB8l+CxF4Pg/oFyEQc7uMrnh3Y7q79SxW2a
         2gRC8nOkOZffw+vZcL0mbO3S6CMtdvHDa4qNU=
MIME-Version: 1.0
In-Reply-To: <20090917091408.GB13002@csn.ul.ie>
References: <202cde0e0909132230y52b805a4i8792f2e287b01acb@mail.gmail.com>
	 <20090914165435.GA21554@infradead.org>
	 <202cde0e0909162342xb2a8daeia90b33a172fc714b@mail.gmail.com>
	 <20090917091408.GB13002@csn.ul.ie>
Date: Mon, 21 Sep 2009 17:16:26 +1200
Message-ID: <202cde0e0909202216i36e3eca3rc56ddde345b12bf9@mail.gmail.com>
Subject: Re: HugeTLB: Driver example
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Munson <linux-mm@mgebm.net>,
       Alexey Korolev <akorolev@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,

> I think Christoph's point is that there should be an in-kernel user of the
> altered interface to hugetlbfs before the patches are merged. This example
> driver could move to samples/ and then add another patch converting some
> existing driver to use the new interface. Looking at the example driver,
> I'm hoping that converting an existing driver of interest would not be a
> massive undertaking.

Converting an existing driver may be a very difficult task as this
assumes involving in development process of the particular driver i.e.
having enough details about h/w and drivers and  having ability to
test the results. Also it is necessary to motivate maintainers to
accept this conversion. So I likely would not to be able change the
third party drivers for these reasons, but I'm open to help other
people to migrate if they want.
I heard that other people were asking you about driver interfaces for
huge pages, if this was about in-tree drivers then we could help each
other. Could you put me in touch with other developers you know of who
are interested in using htlb in drivers? It makes sense to get this
feature merged as it provides a quite efficient way for performance
increase. According to our test data, applying these little changes
gives about 7-10% gain.


> I tend to agree with him.
>
> As I'm having trouble envisioning what a real driver would look like,
> converting an in-kernel driver ensures that the interface was sane instead
> of exporting symbols that turn out to be unusable later. It'll also force
> any objectors out of the closet sooner rather than later.
>
> As it stands, I have no problems with the patches as such other than they
> need a bit more spit and polish. The basic principal seems ok.

Thanks,
Alexey
