Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0CIWrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:47:03 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:56252 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0CIWq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 17:46:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vQsLNQ8yUiKIVMzd6xEFibNJzbDyyp3wZD/3bja8mr05RQrimRupSmh264qfFkc0Xf
         +wLMs4eWChmpUjVEWr5P4d+vf/DkRPeXVp0iFxV7Isa92Je+JjutmJQvOGuJQ8awpGBo
         /rD8QcB86jzHHGFikCDboYZXIfMu+kV2KPm5I=
MIME-Version: 1.0
In-Reply-To: <4B94ACE8.4060400@zytor.com>
References: <4B947393.2050002@kernel.org>
	 <1268031640.4389.11.camel@mulgrave.site> <4B94ACE8.4060400@zytor.com>
Date: Tue, 9 Mar 2010 17:46:58 -0500
Message-ID: <87f94c371003091446h62e50257qf884b278c69cfbfa@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: Greg Freemyer <greg.freemyer@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, mkp@mkp.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
>
> As far as partitioning... I believe we should be using GPT partition tables
> where possible.  Even on non-EFI systems, it's simply a much better
> partition table format.
>
>        -hpa

GPT can not be used for boot disks in non-EFI systems, right?

Greg
