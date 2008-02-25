Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYBYGor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYBYGor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYBYGoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:44:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:48192 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYBYGoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:44:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wcbQqNvwG5Ihp01SGAGCPrA3klzPfYAea7JnUJHniRw9oEY2443ywgHC5XgKwdD+f3JF8Q6nmUy1GbwG/nGfjrnJBaS83IHB1wNOwAg7gCKal4CyxcGp9ulzq2IU9zDftOgIG2X1zl6tuYLsbb3kaqp8UJraW+a3NrWhn6Oh6o0=
Message-ID: <4d8e3fd30802242244s54e478acw1e582f7edf870b88@mail.gmail.com>
Date: Mon, 25 Feb 2008 10:14:36 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH 2/3] IDE: Replace __FUNCTION__ with __func__
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <1203897888.19319.143.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080224221113.5ddfe371@paolo-desktop>
	 <1203897888.19319.143.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/08, Joe Perches <joe@perches.com> wrote:
> On Sun, 2008-02-24 at 22:11 +0100, Paolo Ciarrocchi wrote:
> > -	"driver.\n", __FUNCTION__, drive->name);
> > +	"driver.\n", __func__, drive->name);
>
> Is there consensus on this style conversion?

I did that in a separate patch because i'm not sure about that.

> Right now, there's 629 uses of __FUNCTION__ and 439 uses of __func__.

Checkpatch.pl indicate the conversion as a janitorial task.

Ciao,
--
Paolo
http://paolo.ciarrocchi.googlepages.com/
