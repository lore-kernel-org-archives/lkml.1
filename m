Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYHRPcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYHRPcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYHRPcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:32:13 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:35059 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYHRPcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:32:12 -0400
In-Reply-To: <20080818142511.GC8184@mit.edu>
To: Theodore Tso <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to a linux
 interface for on access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Mon, 18 Aug 2008 16:31:09 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 18/08/2008 16:32:04,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 18/08/2008 16:32:04,
	Serialize complete at 18/08/2008 16:32:04,
	S/MIME Sign failed at 18/08/2008 16:32:04: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/08/2008 16:31:11,
	Serialize complete at 18/08/2008 16:31:11
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080818153212.6A6FD33687F@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote on 18/08/2008 15:25:11:

> On Mon, Aug 18, 2008 at 02:15:24PM +0100, tvrtko.ursulin@sophos.com 
wrote:
> > Then there is still a question of who allows some binary to declare 
itself 
> > exempt. If that decision was a mistake, or it gets compromised 
security 
> > will be off. A very powerful mechanism which must not be easily 
> > accessible.  With a good cache your worries go away even without a 
scheme 
> > like this.
> 
> I have one word for you --- bittorrent.  If you are downloading a very
> large torrent (say approximately a gigabyte), and it contains many
> pdf's that are say a few megabytes a piece, and things are coming in
> tribbles, having either a indexing scanner or an AV scanner wake up
> and rescan the file from scratch each time a tiny piece of the pdf
> comes in is going to eat your machine alive....

Huh? I was never advocating re-scan after each modification and I even 
explicitly said it does not make sense for AV not only for performance but 
because it will be useless most of the time. I thought sending out 
modified notification on close makes sense because it is a natural point, 
unless someone is trying to subvert which is out of scope. Other have 
suggested time delay and lumping up.

Also, just to double-check, you don't think AV scanning would read the 
whole file on every write?

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

