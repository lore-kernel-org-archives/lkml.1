Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZAGM4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZAGM4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZAGM42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:56:28 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:64143 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZAGM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w7azNRDNey8/FhtNkczL9I6vmadRTo0S1p87VnPupO2IUHHN7IVcaS8pzuGqvmYmlJ
         W+44StOG9YxUbJ5FbEGdUEemfumAtK5NSUFTZelgCrzLMNeF191wyJk0cLUYQ5tCtb93
         EbfPv+yFvNActcLpDGTGTe5+3w2L93lEczZ3s=
Date: Wed, 7 Jan 2009 12:56:19 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Changli Gao <xiaosuo@gmail.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107125618.GB9677@ff.dom.local>
References: <20081224152841.GB13113@1wt.eu> <20090106085442.GA9513@ff.dom.local> <20090106094138.GE25644@1wt.eu> <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123902.GA6307@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107123902.GA6307@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 01:39:02PM +0100, Willy Tarreau wrote:
...
> no problem. However, Herbert explained that this fix could not work for
> multiple reasons (refcounting not fixed where the issue really is). BTW,
> I've just tried it, and it crashed again, this time in tcp_send_ack().

I'm extremely sorry! (I don't even expect you'll dare take 3...)

Jarek P.
