Return-Path: <linux-kernel-owner+w=401wt.eu-S935801AbXJPUCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935801AbXJPUCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765421AbXJPUCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:02:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53225 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765438AbXJPUCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:02:13 -0400
X-Sasl-enc: O66dqMHvO4Y7GZ/H8cQ+LFhWLkyH8F1SnYB/6U1RfJyc 1192564931
Date: Tue, 16 Oct 2007 18:02:07 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071016200207.GA23246@khazad-dum.debian.net>
References: <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org> <20071016143124.GB3237@khazad-dum.debian.net> <20071016144016.GA21749@srcf.ucam.org> <20071016165623.GA13643@khazad-dum.debian.net> <20071016184606.GB25181@srcf.ucam.org> <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org> <20071016192010.GA26692@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016192010.GA26692@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Matthew Garrett wrote:
> On Tue, Oct 16, 2007 at 12:14:32PM -0700, Linus Torvalds wrote:
> > IOW, I think the thinkpad issue (and others like it) should be fixed by 
> > splitting up the KEY_VOLUMEUP "key" into separate KEY_VOLUMEUP and 
> > KEY_VOLUMEUP_NOTIFY key events, so that downstream user mode (and the 
> > kernel itself, for that matter) can know whether it's a informational 
> > message or whether it should be acted upon.
> 
> In principle I agree, but userspace already handles it. While it's 
> certainly more correct, I'm not sure it provides any other real 
> advantage.

Let's put it in another way:

I'd go with Linus suggestion, as it is not icky (although it is a lot more
limited in scope than adding a flag to EV_* that could be use for any event,
etc).

I am not going with the current icky hackery that makes every consumer of
EV_* need to know when they are real events, or "notification" events using
outside information.  It is not "userspace already handles it", even.  it is
"HAL already handles it", BTW.

And unless Dmitry agrees with Linus' suggestion (maybe as a temporary
stopgap while something better gets written?), we are not going anywhere,
anyway.  

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
