Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbZKBToN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbZKBToN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbZKBToM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:44:12 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:36431 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbZKBToL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:44:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=HfDY7x0UuOfpfjxUSvn1PZIFBrD6ful4RpHRyKIuaSdArMbXRMgjdlHXE48jiwiwBK
         AzE7xmCtZnjRVXwWvF8roINmqnmKDI97QhSW1a6gIhnxIJRMGrIxpmMmzZu8PlJRIAEN
         2wIpGDHN7kQs1hnNFeCTuEWhrehUbv8XxKHpI=
Date: Mon, 2 Nov 2009 20:44:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       laijs@cn.fujitsu.com, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra
	check
Message-ID: <20091102194412.GD4880@nowhere>
References: <b8bf37780911020926rd5e40b1h957c803f7bb21196@mail.gmail.com> <20091102181944.GA4880@nowhere> <1257186583.28925.47.camel@Joe-Laptop.home> <20091102193248.GC4880@nowhere> <20091102193623.GB9948@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091102193623.GB9948@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 08:36:23PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Nov 02, 2009 at 10:29:43AM -0800, Joe Perches wrote:
> > > On Mon, 2009-11-02 at 19:19 +0100, Frederic Weisbecker wrote:
> > > > On Mon, Nov 02, 2009 at 03:26:36PM -0200, André Goddard Rosa wrote:
> > > > > Subject: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra check
> > > > >    text    data     bss     dec     hex filename
> > > > >   15735       0       8   15743    3d7f lib/vsprintf.o-before
> > > > >   15719       0       8   15727    3d6f lib/vsprintf.o-minus-double-check
> > > > Please add a changelog in your patches, I mean something that
> > > > explain your practical change.
> > > 
> > > Read the subject and try not to go overboard.
> > > I think the changelog André provided is perfect.
> > 
> > 
> > It took me some time yesterday to understand how 
> > ip6_compressed_string() does its job, hence it took me some time to 
> > ensure this patch is safe, hence this reaction for something that 
> > didn't seem obvious to me at a first glance.
> > 
> > But you're right actually, the problem was more in my homework than in 
> > the changelog.
> 
> Since you wrote the last iteration of that bit and you didnt find it 


André wrote this patch, not me :)


> trivial i'd strongly suggest the next version of this patch to include a 
> more verbose changelog that explains what is being done. There's no harm 
> in being verbose about reasons for a change - and there's a lot of harm 
> from being too short.
> 
> 	Ingo

