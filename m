Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYLDABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYLDABU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYLDABK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:01:10 -0500
Received: from ivent.com.au ([125.7.48.1]:59787 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbYLDABJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:01:09 -0500
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Nick Andrew <nick@nick-andrew.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1228347564.10407.18.camel@localhost.localdomain>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <20081203124252.GD11807@mail.local.tull.net>
	 <1228344292.6993.27.camel@lappy.spacevs.com>
	 <20081203230820.4473a162@lxorguk.ukuu.org.uk>
	 <1228347564.10407.18.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 11:00:54 +1100
Message-Id: <1228348854.6993.38.camel@lappy.spacevs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - picard.ivent.com.au
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rabidhost.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be great if you could say 'limit setuid() to saved-uid + uids
> 1000-2000' or something like that.
> 
> If then the userlevel NFS server gets owned you can at least be sure
> none of the files in /bin have been modified ..
> 
> Note that there are patches on the net for linux, freebsd and probably
> other OSes that do exactly this, so there definately is a need.
> 
> It could even be used to give normal users a range of uids to use for
> sandboxes. Just an idea, I haven't really thought that through.
> 
> Mike.
> 

Nice to hear that someone does not think my concept is completly
idiodic. I think the main issue here is that everyone is assuming that
this is only for use with CGI scripts, which could be abused, but as
Mike has mentioned, this is not the only use case. I am sure that with
some hacking and idea bouncing, this problem can be solved, and solved
in a very neat and clean way.

My concept is just that, a concept, build on it, expand it, fill the
gaps, and it will eventually become a working concept worth implementing
(I hope), dont just shoot it to hell.

The setuid/gid concept in linux is very limited, it would be nice to be
able to grant programs limited use of setuid, and even go one step
further, grant programs limited ability to set child uids.

To be completly honest, this is the kind of functionallity I expected to
already be there, and I was hopeing someone would tell me to RTFM on
function X that already does this...

