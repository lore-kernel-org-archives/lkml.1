Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZAFKBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZAFKBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZAFKBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:01:20 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:50046 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZAFKBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-mutt-references
         :x-mutt-fcc:user-agent;
        b=fxcNP1qy1NpdNeUvPgXieLUxh7nd/KlGS26QYjAqMqJ7SI6YU3PMNmsDxh32KeIEuq
         z1qmPE4q+yxkBPp2kmtnB1OiKRa/NDLPvcy8HGkeAyeRMFc6TZslmkwpmLMbRtQBMkbB
         Ty4PIsvLoz6gsBG4Nyz/QDmIf80do+dSoO83o=
Date: Tue, 6 Jan 2009 10:01:13 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090106100112.GB9513@ff.dom.local>
References: <20081224152841.GB13113@1wt.eu> <20090106085442.GA9513@ff.dom.local> <20090106094138.GE25644@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106094138.GE25644@1wt.eu>
X-Mutt-References: <20090106094138.GE25644@1wt.eu>
X-Mutt-Fcc: =outbox
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:41:38AM +0100, Willy Tarreau wrote:
...
> > Great story! Alas I don't understand this fully either, but it seems
> > Changli Gao was concerned with sendpage sending this "as pages", so
> > when NETIF_F_SG flag is available. Did you try this without SG btw?
> 
> No I did not. I can try, it's not too hard. It would in part defeat the
> purpose of the mechanism (especially at 10 Gbps) but at least it will
> help narrow the problem down.

Yes, I meant it only as a proof of concept. BTW, delaying TCP acks a
bit for these sendpages should then make it more reproducible, I guess.

Jarek P.
