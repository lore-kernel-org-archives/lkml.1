Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbZKYHwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbZKYHwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZKYHwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:52:19 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59103 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZKYHwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:52:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=J8ok6NM/V3zfFh6FsBnXmGYYxosaA92TBcpmqPuKoHcXcnznmvAokUJCUwD0HlYSln
         t4+bg2HYU+FUJyidxY1m8aarCqn7icGRyITj3uXxY9DfWggar/mIKT2ALxT2Cv5TLrce
         W//P/LVYHM5irgiJGZ9ujAfujuqpz16ktShKg=
MIME-Version: 1.0
In-Reply-To: <20091124141122.63e81c55.sfr@canb.auug.org.au>
References: <20091124141122.63e81c55.sfr@canb.auug.org.au>
Date: Tue, 24 Nov 2009 23:52:24 -0800
X-Google-Sender-Auth: 9a82c11012ae2c82
Message-ID: <9929d2390911242352l4ff1359dt9a9ecba381df3432@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net tree with the net-current 
	tree
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruce Allan <bruce.w.allan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 19:11, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/e1000e/ich8lan.c between commit
> 818f33313caab9be2a10458500dbed4a88c1b334 ("e1000e: do not initiate
> autonegotiation during OEM configuration") from the net-current tree and
> commit 94d8186a693284344ee5cb9734086c7a2370241a ("e1000e: cleanup ops
> function pointers") from the net tree.
>
> Just context changes. I fixed it up (see below) and can carry the fix for
> a while.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>

I am checking your merge changes to e1000e now, sorry for the delayed response.

-- 
Cheers,
Jeff
