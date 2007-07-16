Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbXGPQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbXGPQoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXGPQoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:44:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:37591 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073AbXGPQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CIcbTq228KlL1n8zhMQuxAJPK0PIh+uDkTAITv3depTJsem81uT6+8Ry1sWPNvVFTws41OCa13rbNZCaFTKetyMrgDG/+aPvdSCvfmlENbEVPNJwEERW5RlsAGmJImxnaFTKad4Nd1sUrXBKHuVxGbfByMwvnu4kLyDpA2DxHJM=
Message-ID: <a781481a0707160944h2f991739p69058208cdf13f76@mail.gmail.com>
Date: Mon, 16 Jul 2007 22:14:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: Hardlink Pitfalls (was: Patches for REALLY TINY 386 kernels)
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707161722.53203.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707161722.53203.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Al Boldi <a1426z@gawab.com> wrote:
> Satyam Sharma wrote:
> > Or just "cp -al" to create multiple trees at (almost) no disk cost
> > that won't interfere with each other in any way, and makes the
> > development process / generating patchsets trifle easier as well ...
>
> That would be correct if hardlinks would actually do a CoW on modify, instead
> of misleading the user into thinking he is modifying an independent file.

"patch" already handles this correctly ... and backupcopy=auto,breakhardlink
in vim (and something similar in other editors I presume)

Satyam
