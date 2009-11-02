Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZKBTcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZKBTcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZKBTcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:32:46 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34483 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbZKBTcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:32:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Gea4g7sRWFCaQPalWta79vmbVRd9LXtku82lozBDHySb8Hab9YXQuccrIDXpOeLC1X
         RXj7NpIUCSHxZ4zS9yj0c5QZBkfUKYYAqfx4rkJc07iy3QikEOSqgE9pdZBjq7qnuM8z
         xO5X6Qf1OCFt47NR/yxnSil5nIoq0TKlXaBeQ=
Date: Mon, 2 Nov 2009 20:32:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra
	check
Message-ID: <20091102193248.GC4880@nowhere>
References: <b8bf37780911020926rd5e40b1h957c803f7bb21196@mail.gmail.com> <20091102181944.GA4880@nowhere> <1257186583.28925.47.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1257186583.28925.47.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 10:29:43AM -0800, Joe Perches wrote:
> On Mon, 2009-11-02 at 19:19 +0100, Frederic Weisbecker wrote:
> > On Mon, Nov 02, 2009 at 03:26:36PM -0200, André Goddard Rosa wrote:
> > > Subject: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra check
> > >    text    data     bss     dec     hex filename
> > >   15735       0       8   15743    3d7f lib/vsprintf.o-before
> > >   15719       0       8   15727    3d6f lib/vsprintf.o-minus-double-check
> > Please add a changelog in your patches, I mean something that
> > explain your practical change.
> 
> Read the subject and try not to go overboard.
> I think the changelog André provided is perfect.


It took me some time yesterday to understand how ip6_compressed_string()
does its job, hence it took me some time to ensure this patch is safe,
hence this reaction for something that didn't seem obvious to me at
a first glance.

But you're right actually, the problem was more in my homework than in
the changelog.

