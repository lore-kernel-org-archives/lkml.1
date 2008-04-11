Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbYDKVAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbYDKVAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760248AbYDKU76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:59:58 -0400
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:57971
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760110AbYDKU75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:59:57 -0400
X-Trace: 4505762/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoFAC5u/0dTQwss/2dsb2JhbACBXalw
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: devzero@web.de
Subject: Re: Western Digital GreenPower drives and Linux
Date: Fri, 11 Apr 2008 22:00:28 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lkml@metanurb.dk, pernegger@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
References: <234148243@web.de>
In-Reply-To: <234148243@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804112200.28854.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >I got back from WD's tech support and received a DOS utility which can
> > control this drive feature, apparently using vendor specific commands.
> > With it head unload timer can be disabled or set to a period between
> > 100ms and 25.5s.

Followup with some good news.

Head unload timer settings seems to be persistent across powering off. Having 
set it to a maximum value of 25.5 seconds my disk is now behaving much more 
reasonable.

To actually do it I used FreeDOS floppy image burnt on a CD-RW as a bootable 
image plus wdidle3.exe in the filesystem itself. 

BTW, WD's tech support has gone silent so chances for an easier solution are 
not so great.

Tvrtko
