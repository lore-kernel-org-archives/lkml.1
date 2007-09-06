Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXIFXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXIFXfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 19:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932652AbXIFXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 19:35:28 -0400
Received: from pat.uio.no ([129.240.10.15]:48402 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599AbXIFXf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 19:35:28 -0400
Subject: Re: NFS4 authentification / fsuid
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Satyam Sharma <satyam@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
	 <1188484155.6755.38.camel@heimdal.trondhjem.org>
	 <1188484337.6755.41.camel@heimdal.trondhjem.org>
	 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
	 <1188486240.6755.51.camel@heimdal.trondhjem.org>
	 <20070830214431.GF10808@fieldses.org>
	 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
	 <20070906150616.GA28565@fieldses.org>
	 <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 01:35:14 +0200
Message-Id: <1189121714.6672.38.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 6F28E0A6B99BAFBFB72C96975D6564B02BDF0B4F
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 158 total 3719429 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 19:30 -0400, Kyle Moffett wrote:
> On Sep 06, 2007, at 11:06:16, J. Bruce Fields wrote:
> > On Thu, Sep 06, 2007 at 01:44:05PM +0530, Satyam Sharma wrote:
> >> Like Trond said, there are very high number of ways in which  
> >> privileged userspace can compromise a running kernel if it really  
> >> wants to do that, root-is-God has always been *the* major problem  
> >> with Unix :-)
> >>
> >> The only _real_ way a kernel can lock itself completely against  
> >> malicious userspace involves trusted tamperproof hardware,
> >
> > The question of how to protect against someone with *physical*  
> > access certainly is more difficult, but surely that's a separate  
> > problem.
> 
> Actually, that's a fairly simple problem (barring disassembling the  
> system and attaching a hardware debugger).  You encrypt the root  
> filesystem and require a password to boot (See: LUKS).  Debian has  
> built-in support for installing onto fs-on-LVM-on-crypt-on-RAID, and  
> it works quite well on all the laptops I use regularly.  It's not  
> even much of a speed penalty; once you take the overhead of hitting a  
> 5400RPM laptop drive you can chew thousands of cycles of CPU without  
> anybody noticing (much).  Then all you have to do is burn a copy of  
> your /boot with bootloader onto some read-only media (like a  
> finalized CDROM/DVDROM) and you're set to go.

Disconnect battery, and watch boot password go 'poof!'.

Trond

