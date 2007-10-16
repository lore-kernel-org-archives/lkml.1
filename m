Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbXJPL4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbXJPL4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 07:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbXJPL4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 07:56:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35104 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbXJPL4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 07:56:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johan Brannlund <johan_brn@yahoo.com>
Subject: Re: Lots of disk activity on resume from s2ram
Date: Tue, 16 Oct 2007 14:12:26 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <pan.2007.10.15.21.53.21@yahoo.com>
In-Reply-To: <pan.2007.10.15.21.53.21@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161412.26407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 15 October 2007 23:53, Johan Brannlund wrote:
> Hi. I've noticed that with recent kernels (starting somewhere between 
> 2.6.20 and 2.6.22) I sometimes get *lots* of disk activity on resume from 
> suspend to ram. About 2/3 of the time, the system resumes normally but in 
> the remaining 1/3 of the time, the hard drive light stays on almost solid 
> and the machine is very, very slow to respond. The only way I've found to 
> reliably recover from this is if I can get to a command prompt fast 
> enough and do "shutdown -r now". There's not much cpu activity at all, it 
> just seems to be disk io that's killing interactivity. This also happens 
> if I resume just from an empty gnome desktop with no applications 
> running, so I don't think it's due to swapping.
> 
> Some kernels affected: 2.6.22, 2.6.23+hrt patches, Ubuntu Gutsy kernel 
> (2.6.22-14). These are all 64-bit kernels running on an HP nx6125 laptop 
> - single-core Turion 64 processor, 1 gig of ram. To the best of my 
> recollection, this problem did *not* appear with 2.6.20.
> 
> I put some dmesg output from the vm block dumping and some vmstat output 
> at http://nullinfinity.org/tmp/s2ram/ . The dmesg logs are from the same 
> resume, just a little while apart. The vmstat is from a different resume.
> 
> Any workarounds, patches, tips for further debugging etc would be 
> appreciated.

Please file a bug report at http://bugzilla.kernel.org , under
"Power management"->Hibernation/Suspend and add my address to the CC list.

Greetings,
Rafael
