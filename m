Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbXB0NZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbXB0NZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbXB0NZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:25:29 -0500
Received: from web52901.mail.yahoo.com ([206.190.49.11]:48175 "HELO
	web52901.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751559AbXB0NZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:25:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TU82VC2u0KXp76iXUCOkFr3YSpybaqe+3NiWfqknH1F0/bVIRThY4V/aRbL1H32scd62HHqI2C+kNBpndOj8gUukerqLJ75bOGAfZxgdK/diNQkGfd+g5PZGGp4DHP6U0yWrxjHsxcesfxIAhuWB9+v40WiPmbbdn/gV1YboCYY=;
X-YMail-OSG: nn9NabkVM1k6RivVFGYgidS.7D94KZwnJoa039Zb82hxolw3vGsWBp1eTmEDyZliSsJjhXoIRm9qRfbIp83x91TnU23ZWKx.54paVb95UBqH4iYgMm9Ve3C4yHjKpmZVjnUGMOk2ucQ-
Date: Tue, 27 Feb 2007 13:25:26 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [Alsa-devel] [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
To: Takashi Iwai <tiwai@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <s5h7iu4heun.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <797678.74613.qm@web52901.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Takashi Iwai <tiwai@suse.de> wrote: 
> snd_timer_global_register() itself doesn't issue any tasklet, so it
> shouldn't be needed.

Hmm, this bug looks interesting:

http://www.ussg.iu.edu/hypermail/linux/kernel/0702.3/0514.html

Yes, my machine *is* a dual P4 with HT enabled...

Cheers,
Chris



		
___________________________________________________________ 
What kind of emailer are you? Find out today - get a free analysis of your email personality. Take the quiz at the Yahoo! Mail Championship. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
