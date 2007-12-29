Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXL2CMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXL2CMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXL2CMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:12:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:51676 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbXL2CMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:12:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SVdFiY4jYhQa+M2I/i07qZElh5ujPj2a6ZNz6KhNLxkzoZ1cf4Oanvshk2BAZCGG2o0o9GVUIHJeNsSGAS+rD9d46ROO48ytAa57K/fpBcD9IGGCUXf6CnHoinXltoBtCu7RCmz3UR0m5f9ZtgYkx2gu3L66nI+M8N4N8UvzZks=
Message-ID: <3cce60f30712281812v5f7ce335l35d698553449187a@mail.gmail.com>
Date: Fri, 28 Dec 2007 18:12:39 -0800
From: "Shannon Nelson" <shannon.lee.nelson@gmail.com>
To: "=?ISO-8859-1?Q?Gustavo_Guillermo_P=E9rez?=" <gustavo@compunauta.com>
Subject: Re: Corrupted Hard Drive after activating intel I/oat dma
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200712271949.02116.gustavo@compunauta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200712271949.02116.gustavo@compunauta.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 27, 2007 5:49 PM, Gustavo Guillermo Pérez <gustavo@compunauta.com> wrote:
> By mistake we activate intel I/oat dma support on a laptop with a centrino duo
> to try to get better performance on IO.
>
> The wd1200bevs Western Digital Scorpio 120GB HD fails with bad sectors and
> power down (randomly) after booting linux with this option enabled, and
> rebooting with old options does not help, I'm just reporting it, cause we can
> think on a power failure too, but the only change was that, and linux start
> up take too long and HD activity was so hard. I know the option was not
> supported, but I want to know if cause that we can have a fried hd :(.

I highly doubt that ioatdma could break a harddrive, as it is only
used by the networking stack.  Besides, the driver will only be useful
on a server type motherboard using a chipset that supports ioatdma.
This is not the case with a Centrino-based machine.

By the way, you might try checking the Maintainer's file to find out
who supports that module and copy them directly.  If they're at work
this week they might have a more official answer.

sln
-- 
==============================================
Mr. Shannon Nelson         Parents can't afford to be squeamish.
