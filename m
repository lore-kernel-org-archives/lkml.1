Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYAVTtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYAVTtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYAVTtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:49:09 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:61482 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbYAVTtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:49:08 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mika =?ISO-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <479634A9.1090908@zytor.com>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
	 <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	 <47939363.8040603@kolumbus.fi>
	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>
	 <479510CE.7010706@zytor.com>
	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>
	 <479551FD.5040801@zytor.com>
	 <1201023401.5643.52.camel@localhost.localdomain>
	 <479634A9.1090908@zytor.com>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 19:48:45 +0000
Message-Id: <1201031325.15491.66.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 10:23 -0800, H. Peter Anvin wrote:
> Ian Campbell wrote:
> > Anyhow, I don't feel all that strongly about it so if the opinion of the
> > early start of day maintainer(s) is strongly in favour of ASM I'll defer
> > to that.
> > 
> 
> My opinion is that I want it done properly (PIC and all that jazz) or 
> not at all, and certainly would not want to mix linear and 
> paging-enabled code in the same file.  When it comes to assembly code, 
> at least people can *see* that there there be dragons.
> 
> The plus *and* minus of a C version is that it's easier for people to 
> modify.  The plus side of that is that if we really need it, it's a lot 
> cleaner; the minus side is that it may encourage more code to creep into 
> the pre-paging code, which would not be a good thing IMO.

Seems reasonable to me. I'll integrate your asm diff with the other
changes and give it a whirl.

Ian. 
-- 
Ian Campbell

Never go to bed mad.  Stay up and fight.
		-- Phyllis Diller, "Phyllis Diller's Housekeeping Hints"

