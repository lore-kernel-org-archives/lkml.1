Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXL0IuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXL0IuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 03:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXL0IuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 03:50:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:63888 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbXL0IuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 03:50:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UhiTr54Nd/SW2UmPC+YP4Bd+rk7bG8Y1RnM6j/7qUevL4V6txTtPiHLhz7wvq1fj894dMEIbX7DZC3Mhb/wCU2zfqh5ofx3Dqewh3bwoZmzNznJpKEgHmVEC6DCcfM7O8mB5MjZDTVuIVVFyq427IPE98pfwvlJToMJ5QaXrmgA=
Message-ID: <c70ff3ad0712270050u134616d1q459ed073c586dcec@mail.gmail.com>
Date: Thu, 27 Dec 2007 10:50:04 +0200
From: "saeed bishara" <saeed.bishara@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: read-ahead in NFS server
Cc: linux-kernel@vger.kernel.org, "NFS list" <linux-nfs@vger.kernel.org>
In-Reply-To: <47730F2F.3080900@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c70ff3ad0712260351i6583aa8dpbf16ed606a634b1f@mail.gmail.com>
	 <47730F2F.3080900@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (linux-nfs added to cc)
>
> I cannot speak for the NFS server code specifically, but 32kb sounds
> like a network read (or write) data size limit.
yes
>
> Are you using TCP?  Are you using NFSv4, or an older version?
I'm using NFSv3/UDP.
I found that the actual requests size was 16KB, after doing some hacks
in server&client I managed to make it 60KB, now I see better
performance, and I see that the average request size is ~130KB which
means that there is actually read-ahead. but why it's only 130KB? how
can I make it larger?
when I run local dd with bs=4K, I can see that the average IO size is
more than 300KB.
