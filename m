Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYHSIKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYHSIKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYHSIJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:09:46 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:50143 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbYHSIJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:09:44 -0400
In-Reply-To: <e7d8f83e0808181815v5ef628ebl3105197f03f4d334@mail.gmail.com>
To: "Peter Dolding" <oiaohm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to	a linux
 interface for on access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: douglas.leeder@sophos.com
Date: Tue, 19 Aug 2008 09:09:50 +0100
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/08/2008 09:08:46,
	Serialize complete at 19/08/2008 09:08:46
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080819080948.4688B3067D2@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

malware-list-bounces@dmesg.printk.net wrote on 2008-08-19 02:15:49:

> You will see latter where what you just said fails and its issue is
> preventable too downloader with build in previewer.
> 
> Funny enough solution to this is fairly simple.   But does require
> looking at a white list methods and LSM.
> 
> Two major ways.    White list format check method tells you that file
> is not complete enough so black list scanning is not required yet.  Ok
> lighter than running 5000 black list signatures over it each time a
> new block gets added.


You seem to have some very funny ideas about what white-listing and 
black-listing 
scanners do.

Checking filetypes and checking for complete/non-corrupt files is 
something
black-listing scanners do.

Where-as whitelisting: 
"An emerging approach in combating viruses and malware is to whitelist 
software which is considered safe to run, blocking all others"

While ensure media files are complete could be done by a scanner that
also does white-listing, I don't think it's a core part.

> Dealing with bittorrent clients with built in preview is a pain in the
> you know what.   Since are they reading the file to send to someone
> else are they reading the file to display in there internal viewer or
> do they take straight from there download buffer to internal view.
> Even worse lots of bittorrent streams are encrypted and cannot be
> scanned while network packets.   So second solution required a LSM
> around the downloader preventing it in case of breach being able to go
> anywhere in the system.   LSM only allows access to files that the
> downloader has downloaded by other applications with more rights when
> its pasted White list and needed black list scanning.

So?

We not talking about throwing away LSM, or replacing it in any way.

This discussion is about an additional scanning path, for files, for any 
kind of content-based 
scanning.


> 
> Getting this to work without using white list of known format method
> and LSM is basically imposable because a black list is going to take
> far to much cpu time scanning incomplete files.

So?


> Lot of windows anti-virus people are way too focused on black list.
> White list might annoy you from time to time but it can also grant
> features that users may not want to give up.

The thing is Windows has had built-in white-listing for a long
time, and yet there is still a market for AV scanners, this suggests 
people don't like white-listing.

Also consider all of the problems and criticism Vista's UAC has had. And 
UAC is 
only white-listing privileged operations. 

-- 
Douglas Leeder

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

