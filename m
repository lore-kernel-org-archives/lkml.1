Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYCYBqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYCYBqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 21:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYCYBqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 21:46:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:42585 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYCYBqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 21:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cFXmOwyfk6DEjbUPJhWQLWrBUwWfyiNaQpf7wG9csfGFiKxjNENjmxOxiMbwTzPfDYj9x80Y4d6AdV4egYIlas/WICIJgHHLYC9pn0O7OOYHQ5M40CPJYHii3dC2pYjYuJUmrl5DEUL36newJf3jgVpHG3Hy55L2Uc3V1QmsWp0=
Message-ID: <5501535d0803241846k69f68738mda1aa6d10f1baa49@mail.gmail.com>
Date: Tue, 25 Mar 2008 02:46:21 +0100
From: "Bjoern Olausson" <lkmlist@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Burning CDs as user produces coasters (Plextor drive)
Cc: "Gregor Jasny" <gjasny@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
In-Reply-To: <47E8142D.4040301@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9d2cd630803241039m79c47754v6562404133a61274@mail.gmail.com>
	 <47E8142D.4040301@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/24/08, Jeff Garzik <jeff@garzik.org> wrote:
> Gregor Jasny wrote:
>  > Hi,
>  >
>  > since some time burning ISO CD images as user fails.
>  > Wodim stops during OPC and the kernel prints some messages:
>  >
>  > scsi: unknown opcode 0xe9
>  > scsi: unknown opcode 0xed
>  > scsi: unknown opcode 0xf5
>  > scsi: unknown opcode 0xeb
>  >
>  > If I burn as root, everything works fine. The used CD writer is a
>  > "PLEXTOR  DVDR   PX-712A   1.09". I've seen in the wodim/cdrecord
>  > sources that plextor drives are handled different from other drives.
>  >
>  > Do you know what the above listed commands are for?
>  > Maybe they could be included in blk_verify_command?
>  > If your'e not sure about the dangerousness maybe as a config option?
>
>
> What drivers and kernel versions work (and which fail)?
>
>         Jeff
>
>

The PX-712A still doesn't work right? Maybe it is related to the bug:
http://bugzilla.kernel.org/show_bug.cgi?id=8918

Tejun has the dirve, but nothing new for now.
http://bugzilla.kernel.org/show_bug.cgi?id=8918

regards
Bjoern
