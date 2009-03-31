Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbZCaGKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbZCaGKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761706AbZCaGKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:10:38 -0400
Received: from smtp-out-41.synserver.de ([217.119.50.41]:1512 "HELO
	smtp-out-41.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753625AbZCaGKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:10:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 19388
Date: Tue, 31 Mar 2009 09:10:18 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       corbet@lwn.net
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2927 tcp_ack+0xd55/0x1991()
Message-ID: <20090331071018.GA2641@gentoox2.trippelsdorf.de>
References: <20090327211202.GA10014@gentoox2.trippelsdorf.de> <Pine.LNX.4.64.0903280031080.5904@wrl-59.cs.helsinki.fi> <20090328045056.GA2394@gentoox2.trippelsdorf.de> <Pine.LNX.4.64.0903280930440.6696@wrl-59.cs.helsinki.fi> <20090328095514.GA2599@gentoox2.trippelsdorf.de> <Pine.LNX.4.64.0903301155150.30150@wrl-59.cs.helsinki.fi> <20090330164035.GA2652@gentoox2.trippelsdorf.de> <Pine.LNX.4.64.0903302137100.29272@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0903302137100.29272@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 09:52:55PM +0300, Ilpo Järvinen wrote:
> On Mon, 30 Mar 2009, Markus Trippelsdorf wrote:
> 
> > On Mon, Mar 30, 2009 at 07:01:22PM +0300, Ilpo Järvinen wrote:
> > > On Sat, 28 Mar 2009, Markus Trippelsdorf wrote:
> > > > On Sat, Mar 28, 2009 at 10:29:58AM +0200, Ilpo Järvinen wrote:
> > > 
> > > ...And, let me guess, you're in X and therefore unable to catch a final 
> > > oops if any would be printed? It would be nice to get around that as well, 
> > > either use serial/netconsole or hang in text mode while waiting for the 
> > > crash (should be too hard if you are able to setup the workload first 
> > > and then switch away from X and if reproducing takes about an hour)...
> > 
> > OK, I will try this later.
> 
> Lets hope that gives some clue where it ends up going boom (if it is 
> caused by TCP we certainly should see something more sensible in console 
> than just a hang)... ...I once again read through tcp commits but just 
> cannot find anything that could cause fackets_out miscount, not to speak 
> of crash prone changes so we'll just have to wait and see...

The machine hanged again this night and I took two pictures:
http://www.mypicx.com/uploadimg/1055813374_03302009_2.jpg
http://www.mypicx.com/uploadimg/1543678904_03302009_1.jpg

But this time there was no tcp related warning in the logs.

I then pulled the lateset git changes, rebuild, rebooted and setup the
workload again. The machine was still up and running in the morning 
(~4 hours uptime). So it may well be that the issue was fixed with
the latest changes. If it ever occurs again I will notify you.

Thanks for your assistance so far,

-- 
Markus
