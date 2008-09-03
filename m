Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbYICPEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbYICPEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYICPD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:03:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:38434 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbYICPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AxZdMFc2ekvf83cpwxG7PuhmzGqALywWZla2tBwncpPzehqNKp5wkeBmlU28LnlHIM
         zxRvXk6npn1s4xpD4eoiVKTsQurkah9nZR8ElSXCckpWyokIJGBu8/YwPUS6vERKwi5a
         V+x8ojNpLy+UKRkL9zmTqydczJhfPK1Jcx84Q=
Message-ID: <48f7fe350809030803q6f4c4d69j9617ed266b86eb8d@mail.gmail.com>
Date: Wed, 3 Sep 2008 11:03:55 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Toei Rei" <toei.rei@stargazer.at>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs-stable/extent-tree.c:2111!
In-Reply-To: <200809031700.47477.toei.rei@stargazer.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350809030752s329a0d09y27530d22237c57ba@mail.gmail.com>
	 <200809031700.47477.toei.rei@stargazer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I dont think that is the case, the compressed reiser4 partition only
had 1.6gig of data, uncompressed on my ext3 partition is about 2.2
gig. The btrfs image I made was 3gig so I dont think it ran out of
space.

-Ryan

On Wed, Sep 3, 2008 at 11:00 AM, Toei Rei <toei.rei@stargazer.at> wrote:
> Hi Ryan,
>
> I'm not sure, but if you'd ask me, this looks like the btrfs partition is
> full. Btrfs cannot handle the disc full event yet!
>
> Rei
>
