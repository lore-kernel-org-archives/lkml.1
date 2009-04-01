Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbZDABRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbZDABRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbZDABRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:17:37 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:53592 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478AbZDABRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vh91mIcRQzy4YGlme0ZVkBB6hgSlrwD1Sz/DGBaBCL2X87eXdGaSbAuN57xfR0Xinr
         +nCDlI1JiF7sCMwt64ImOce5EkZOhNC2IROT42fzm9lagTSRVVyheW4CxOSpI1bL2jV1
         +HG9WWG0OqphautGtaJXkIpKJ9xaKXhgdq0iE=
MIME-Version: 1.0
In-Reply-To: <200903311418.53772.david-b@pacbell.net>
References: <200903260042.42091.david-b@pacbell.net>
	 <200903311418.53772.david-b@pacbell.net>
Date: Tue, 31 Mar 2009 18:17:29 -0700
Message-ID: <a95a62fe0903311817i76f9f6d8qf7470fd14a62b912@mail.gmail.com>
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 2:18 PM, David Brownell <david-b@pacbell.net> wrote:
> Hmm, no comments?  I had understood there was interest over on
> the MTD side of things in exposing more information through
> sysfs, to help avoid the need to add Even More Ioctls as part
> of support for things like NAND chips with 4KB pages, or which
> handle more than 4GBytes ...

Based on this post:
http://lists.infradead.org/pipermail/linux-mtd/2009-March/025060.html

I am inferring that the following attributes are wanted in the MTD
sysfs interface:

1) mtd_info_user fields - type, flags, size, erasesize, writesize,
oobsize.  So far we have "type," but it should be easy to add the
rest.

2) region_info_user fields?  Not really sure how this would work.
Maybe a separate subdirectory for each region?
