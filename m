Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033Ab0A3Xtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0A3Xtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 18:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655Ab0A3Xte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 18:49:34 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:59142 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0A3Xtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 18:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BDkG4cLKtHzWfbLnFuYLd/8WoYN5G2PkmnKKXao/Hb6ZzKgsAYFUFMaf5DUbH+grdO
         AOZhqJ2ulXYvSFk6YgGkrTYT1snROEVpeRwZWGVCerPDvcyvTcfZg7wh7/whR52sOvA4
         E3u2JkFQ++CxwLfdZqGfNuJTUFclYqBjMth5s=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001301100450.3006@localhost.localdomain>
References: <524f69651001292008g39c796a7j6f41c04b599752c7@mail.gmail.com>
	 <alpine.LFD.2.00.1001301100450.3006@localhost.localdomain>
Date: Sat, 30 Jan 2010 17:49:31 -0600
Message-ID: <524f69651001301549v2db7e155tfdb3ce18cfae035@mail.gmail.com>
Subject: Re: [patch 05/10] cifs: convert semaphore to mutex
From: Steve French <smfrench@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 4:03 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 29 Jan 2010, Steve French wrote:
>> > Looks good, but I'm pretty sure I've seen an equivalent patch on the
>> > linux-cifs-client list before.
>> >
>> >
>> > Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> Jeff and I acked the cifs part of the patch series in July - not sure
>> why the series didn't go in.
>>
>> http://marc.info/?l=linux-kernel&m=124859649902788&w=2 looks like the
>> original post
>
> Yeah, the patch was part of a larger series which had problems here
> and there. I forgot to split it out and push it seperately.
>
> Steve, can you pick that up and push it via the cifs tree ? It's
> completely stand alone and does not depend on other patches.

np - will queue for 2.6.34


-- 
Thanks,

Steve
