Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbXA0Smo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbXA0Smo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbXA0Smn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:42:43 -0500
Received: from web52509.mail.yahoo.com ([206.190.48.192]:49097 "HELO
	web52509.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752329AbXA0Smn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:42:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=l6AUqomEXnRgE09PZ8BJLdZnFbyyjdc58RioR22tDsjVhIEnTFDlFMuZvZDqEAToaGdcjTFwd86ed8NSy2b7gtelNZ/WS4QZoG9ASoPhuY6EqPrKkO/7wk79F3mLNL1hUr5JVJspcT+Bm23f2s3YLgQ6CTuIusLCxJhQSMct2Ls=;
X-YMail-OSG: W_QFwG4VM1mPNTXeJRV2o2rsNK25b8q.YAYyS7g1u4E49u.P.h74J081Dy.UxHieK9PCEJeTbRJDaekwCHFawH.mnd8s45o2kFK_F3tUIZBCAfcl26SH_O32BSLzRXaTVYYIhtkr4L6MApo-
Date: Sat, 27 Jan 2007 10:42:42 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Raid 10 question/problem [ot]
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0701271931260.22295@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <197171.96132.qm@web52509.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Jan 27 2007 10:31, Marc Perkel wrote:
> >--- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> >> 
> >> >I'm a little stumped trying to set up raid 10. I
> >> set
> >> >it up and it worked but after a reboot it
> forgets
> >> my
> >> >raid setup.
> >> 
> >> Now, let's hear the name of the distribution you
> >> use.
> >> 
> >> BTW, is md1 also disappearing?
> >
> >Sorry about that. I'm using Fedora Core 6. /dev/md0
> >and /dev/md1, buth of which are raid 1 arrays
> survive
> >the reboot. But when I make a raid 0 out of those
> two
> >raid arrays that's what is vanishing.
> 
> That's interesting. I am using Aurora Corona, and
> all but md0 vanishes.
> (Reason for that is that udev does not create the
> nodes md1-md31 on
> boot, so mdadm cannot assemble the arrays.)
> 


What do you have to do to get UDEV to create /dev/md2?
Is there a config file for that?



 
____________________________________________________________________________________
Do you Yahoo!?
Everyone is raving about the all-new Yahoo! Mail beta.
http://new.mail.yahoo.com
