Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbXCPTwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbXCPTwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXCPTwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:52:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:37224 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbXCPTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oeAc2e7qYp5QTA6j0IEZzHfqo/LRNCNbtTjeLpiAkHwXQWpGOlCt0bIAHTz+unv6Ft8TZD1LqiEwPHU40Mv01ArozM0DIvrMcJ+Ks9Ki4G/x5rvzR+ArrIDhPJ8onQ864xK/nxj4eMif+5YDY06j3Slq6GxXxu9nOB6+dD1pGZI=
Message-ID: <75b66ecd0703161252l60dcbd81s3c9beb7cb91b6c14@mail.gmail.com>
Date: Fri, 16 Mar 2007 15:52:12 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "John Coppens" <john@jcoppens.com>
Subject: Re: Conflict between ide and usb?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070316154735.6de11eca.john@jcoppens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070316154735.6de11eca.john@jcoppens.com>
X-Google-Sender-Auth: dbefb52cea7ba5ba
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, John Coppens <john@jcoppens.com> wrote:
> The problem I have, is that when I copy a file from a DVD to harddisk,
> the internet connection almost dies (it slows down terribly, so much so
> that established connections actually disconnect, ping looses packets,
> DNS lookup fails, etc). After copy ends, all returns to normal.

Sounds like DMA starvation, it's been seen in the past with some SATA
controllers.  Presumably vendors do it to improve benchmark scores.

You can confirm it by forcing the hard drive and/or DVD drive to a
lower speed if your BIOS allows it.

Lee
