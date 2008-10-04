Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYJDAgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYJDAgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 20:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYJDAf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 20:35:56 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58743 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbYJDAfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 20:35:55 -0400
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 20:35:55 EDT
Message-Id: <1223079192.516.1277443601@webmail.messagingengine.com>
X-Sasl-Enc: CaKSjRYo0Bq47CKxEK1rgrVxPoNOY5gE3P+KC+fpeJDM 1223079192
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <npiggin@suse.de>, "Rob Mueller" <robm@fastmail.fm>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       stable@kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1213682410.13174.1258837181@webmail.messagingengine.com>
 <1213682570.13708.1258839317@webmail.messagingengine.com>
 <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
 <20081003114414.GA14390@brong.net>
 <20081003060723.7184a1ed.akpm@linux-foundation.org>
Subject: Re: BUG: mmapfile/writev spurious zero bytes still in the wild
In-Reply-To: <20081003060723.7184a1ed.akpm@linux-foundation.org>
Date: Sat, 04 Oct 2008 10:13:12 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Oct 2008 06:07:23 -0700, "Andrew Morton" <akpm@linux-foundation.org> said:
> On Fri, 3 Oct 2008 21:44:14 +1000 Bron Gondwana <brong@fastmail.fm>
> wrote:
> > Is there a standard way to tell backporters "you really need to add this
> > patch for your users' sanity"?
> 
> Yes, there is.  We backport the patch into earlier kernel releases and
> that action _should_ wake the distros up to take a look at the fix.
> 
> This particular fix (42a886af728c089df8da1b0017b0e7e6c81b5335) was
> included in 2.6.26 and also is present in 2.6.25.17, but not 2.6.25. 
> So we did backport it into 2.6.25.x.  Maybe distros were slow or errant
> in picking up the patch.

It went into 2.6.25.8, which was the stable line at the time.  It
didn't get backported to 2.6.24.  Ubuntu's stable line is called
2.6.24-19.41, and I'm guessing they just didn't realise it was
a fix that actually needs to be applied to everything back to at
least 2.6.23.

I'll go try launchpad again and see if it's unbroken enough to
accept my bug report.

Bron ( really not wanting to keep fielding Cyrus questions on this
       for the 4 1/2 years support remaining on that LTS distro! )
-- 
  Bron Gondwana
  brong@fastmail.fm

