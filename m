Return-Path: <linux-kernel-owner+w=401wt.eu-S1751013AbXBMUUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbXBMUUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbXBMUUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:20:41 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:1294 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXBMUUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:20:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=C1L8+HSRra0yY+l82kMi3tPiFMvvm8Xi7GJtlrgAKGABpSQ63qs9lK5EFFSQl9x++M+pwd8b3rhd4Fi3jOGSn9jzAaaVLiITdsKfPtBczmExvWGnEl1Tkx5hLOnEs/TRkfP4DningI3/QRM+EMPZLyEybcJYs96JoTgFgOUgXkk=
Message-ID: <45D21D83.1070006@gmail.com>
Date: Tue, 13 Feb 2007 12:20:19 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Alan'" <alan@lxorguk.ukuu.org.uk>, "'Robert Hancock'" <hancockr@shaw.ca>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: AHCI - remove probing of ata2
References: <021801c74f41$54179a50$4b00a8c0@donald>
In-Reply-To: <021801c74f41$54179a50$4b00a8c0@donald>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

Paul Rolland wrote:
> Also, please note that libata is complaining :
> ATA: abnormal status 0x7F on port 0x177
> and later :
> ATA: abnormal status 0x7F on port 0x9807

You can ignore the above.  The errors on ata2 are due to SIMG storage 
processor and will probably fixed when PMP support is implemented.  The 
latter errors on pata_jmicron is probably due to lack of proper mode 
programming on that driver.  I'll look into that.

Thanks.

-- 
tejun
