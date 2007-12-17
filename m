Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbXLQSuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbXLQSuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXLQSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:50:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:15339 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXLQSuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:50:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QewXNjTAiECVgR9b2JP1BwvFrT8BR8sffz2UrwWi2XjC45gkxbqOp9t1yvZfhvvg3R8uVZzrLw+Yn2gjAmdyPB2vEf2qdq+MUlnSM3FEf91o/lV71ql5fyUpPiTMtboorq4zp4SZhV825QNdusOVFxvbSHw1mhIxnYUZX9i8cRY=
Message-ID: <7f45d9390712171050u751547daif8526807eae0cb8a@mail.gmail.com>
Date: Mon, 17 Dec 2007 11:50:12 -0700
From: "Shaun Jackman" <sjackman@gmail.com>
Reply-To: "Shaun Jackman" <sjackman@gmail.com>
To: "David Keeffe" <david@systemsolve.net>
Subject: Re: External PHY in Linux smc91x driver
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4765ECCD.8030309@systemsolve.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4765ECCD.8030309@systemsolve.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, (cc'ed to LKML)

The patch, `smc91x: Add support for an external PHY' from 2006-07-19,
worked for me. It simply set the extphy bit of the smc91x to disable
the internal PHY and use the external MII interface. As you can see
from the patch, it doesn't support configuring the external PHY in any
way. Most PHYs power up to a default functional state. In further
work, someone could add the smc91x MII configuration interface to the
PHY abstraction layer. Incidentally, the PHY I was using (an unmanaged
switch chip) didn't even support configuration over the MII interface.
Apply this patch first as a minimum first measure. Test the patch, if
it works for you, sign off on it and repost it to the LKML.

Cheers,
Shaun

On Dec 16, 2007 8:28 PM, David Keeffe <david@systemsolve.net> wrote:
> Hi Shaun
>
> I've been asked to look at supporting an external (LXT) PHY for the
> SMC91x driver, and I noticed that you have published a patch for this.
> Is that all that's needed to make the SMC chip work with an external
> PHY? Presumably there are also parts which actually do the phy setup (if
> it's not an SMC component).
>
> I've been considering changing the driver to use the PHY abstraction
> layer, but that seems a big job if the problem has already been solved!
>
> Would you care to share what you've achieved?
>
> David Keeffe
