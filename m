Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYHRQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYHRQ2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYHRQ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:28:27 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:40802 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbYHRQ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:28:26 -0400
In-Reply-To: <20080818142511.GC8184@mit.edu>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to	a linux
 interface for on access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: douglas.leeder@sophos.com
Date: Mon, 18 Aug 2008 17:28:32 +0100
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/08/2008 17:27:29,
	Serialize complete at 18/08/2008 17:27:29
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080818162830.F0BAA3F608F@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

malware-list-bounces@dmesg.printk.net wrote on 2008-08-18 15:25:11:

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

What size is a tribble? :-)

If we assume that the bittorrent client is closing and re-openning the 
file 
each time it's got a nice piece of the file? (Otherwise I don't think
we'll have a performance problem)

Then there maybe room for a optimisation of the following form:
For a file X.
If X is only a local disk.
If X was written from empty by process A and only process A.
Then don't scan attempts to open by process A.

But that sort of optimisation can either be done in user-space, or in a 
future 
kernel modification.

I haven't fully analysed this - it assumes that reading data into process 
A, that
process A wrote out is safe, regardless of the data. 

-- 
Douglas Leeder

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

