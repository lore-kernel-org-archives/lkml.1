Return-Path: <linux-kernel-owner+w=401wt.eu-S1161376AbXBGQ1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161376AbXBGQ1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161377AbXBGQ1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:27:03 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35905 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161376AbXBGQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:27:00 -0500
Message-Id: <1170865619.16808.1173403963@webmail.messagingengine.com>
X-Sasl-Enc: ooTbtjuBDzac3YI48wV6Yyni5aNBL4dx3AUPAQEzIsHI 1170865619
From: "Kai" <epimetreus@fastmail.fm>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
   <20070205203750.7be7f772.akpm@linux-foundation.org>
   <17864.4339.925700.626157@notabene.brown>
   <17865.3776.511594.763544@notabene.brown>
Subject: Re: [PATCH] Re: Bio device too big | kernel BUG at mm/filemap.c:537!
In-Reply-To: <17865.3776.511594.763544@notabene.brown>
Date: Wed, 07 Feb 2007 08:26:59 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 Feb 2007 10:26:56 +1100, "Neil Brown" <neilb@suse.de> said:
> On Tuesday February 6, neilb@suse.de wrote:
> > 
> > This patch should fix the worst of the offences, but I'd like to
> > experiment and think a bit more before I submit it to stable.
> > And probably test it too - as yet I have only compile and brain
> > tested.
> 
> Ok, I've experimented and tested and now I know what was causing the
> double-unlock.
> 
> The following patch is suitable for 2.6.20.1 and mainline.  There is
> room for a bit more improvement, but only for performance, not
> correctness.  I'll look into that later.
> 
> Thanks,
> NeilBrown

I figure I should test this on my hardware, but since the RAID array
resynched itself when I rebooted back into an earlier kernel version,
I'm guessing it means this bug introduced some corruption into the
array, when it occurred, so I'd like some pointers on how I can test it
out without compromising my data.
