Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbZEKOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbZEKOjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZEKOja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:39:30 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:62331 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZEKOj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LJVqFIQg6eIb6KSVc+8sMXVrOpQ76kJL46w51aD8QPA8K6kilaDQSZmcuwi5YMVaFS
         fCjoT+zkiV1GD7pe8+llpF1o8z0TEcjD1UF3JOUFurBtrnDTDepOT9bKTufUQAzSSLdf
         x7XSKWYlDmkjSvHRuvHuZQi4TwiD3pMajVY9I=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0905110824560.7447@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905110740230.7176@venus.araneidae.co.uk>
	 <20090511070029.GA20226@infradead.org>
	 <Pine.LNX.4.64.0905110824560.7447@venus.araneidae.co.uk>
Date: Mon, 11 May 2009 22:39:28 +0800
Message-ID: <f17812d70905110739n1665120fncd6f6dcf798cae79@mail.gmail.com>
Subject: Re: [PATCH] Export GPIO control symbols from mfp-pxa2xx.c
From: Eric Miao <eric.y.miao@gmail.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 3:28 PM, Michael Abbott <michael@araneidae.co.uk> wrote:
> On Mon, 11 May 2009, Christoph Hellwig wrote:
>> On Mon, May 11, 2009 at 07:43:29AM +0100, Michael Abbott wrote:
>> > With very lightweight board support providing a number of uncommitted GPIO
>> > pins I found that my out of kernel driver needs to call symbols that
>> > aren't actually exported.  This patch adds these exports.
>> As usual we don't export symbols for out of tree drivers.
>
> I understand that's the default condition, but presumably there's no
> compelling reason for the mfp configuration functions to be withheld (I
> was simply trying to obey the obsolescence instructions in pxa2xx-gpio.h!)
>
> As for bringing this driver in tree?  Not a great deal of point, in this
> particular case, but I have no problem with doing that.
>

I don't see many real requirements here to export them for the moment.
By keeping these functions/symbols not-exported, I'd expect board-specific
code (usually manipulation of these pins are board-specific) to be kept
in the "board.c" as well, which I do think is a good practice.

Since your driver is out of the tree, you can certainly keep this change
out of the tree as well :-)
