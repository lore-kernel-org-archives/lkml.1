Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbXFDOYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbXFDOYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXFDOY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:24:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:24833 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbXFDOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IBdKLWT0oLjEmiE439gcurhogG20jyfl6AdXE176HNVJ84/F/ic/Tj+w+A+iQ6ILvyDIkPIjirj5Eot+SXPlCkMkwpuQhm+Wo1JnIlp0KEJg8CQ88Et5y1oGE9HVIOIoJTj1xzk95XHi6kMtlxocTrCyOk0xMtUrY7hl+YdoJsQ=
Message-ID: <e7ca40f70706040724k6c5983dalcfc33ad905838bc@mail.gmail.com>
Date: Mon, 4 Jun 2007 10:24:23 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: "John Stoffel" <john@stoffel.org>
Subject: Re: slow open() calls and o_nonblock
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <18020.7945.364135.889997@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	 <20070604144918.42354235@the-village.bc.nu>
	 <e7ca40f70706040704w450dd609g46b6e7a3689ff11@mail.gmail.com>
	 <18020.7945.364135.889997@stoffel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, John Stoffel <john@stoffel.org> wrote:
>
> So how many files are in the directory where you're seeing the delays?
> And what's the average size of the files in there?

The directories themselves will have a maximum of 160 files, and the
files are maybe a few megs each - the delays are (as you pointed out
earlier) due to the ram restrictions and our filesystem design of very
deep directory structures that Netapps suck at.

My point is more generic though - I will come up with ways to handle
this problem in my application (probably with threads), but I'm
griping more about the lack of a kernel interface that would have
allowed me to avoid this.

-Aaron
