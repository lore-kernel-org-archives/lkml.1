Return-Path: <linux-kernel-owner+w=401wt.eu-S932552AbYBTTFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbYBTTFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbYBTTFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:05:15 -0500
Received: from smtp01.isdsl.net ([196.26.208.190]:50607 "EHLO smtp01.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382AbYBTTFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:05:12 -0500
X-netsentry.modernarch.co.za-MailScanner-Watermark: 1204139078.04588@0p2w1sv0YinSjsKEhdXtiQ
Message-ID: <47BC79C9.8010102@networksentry.co.za>
Date: Wed, 20 Feb 2008 21:04:41 +0200
From: Gregory Nietsky <gregory@networksentry.co.za>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tilman Schmidt <tilman@imap.cc>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BC5B5B.90308@firstfloor.org>
In-Reply-To: <47BC5B5B.90308@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-netsentry.modernarch.co.za-MailScanner-Information: Please contact Network Sentry  for more information (www.networksentry.co.za)
X-netsentry.modernarch.co.za-MailScanner: Found to be clean
X-netsentry.modernarch.co.za-MailScanner-From: gregory@networksentry.co.za
X-Scan-Signature: fd24d7d1829becc8240b5a17cae73465{41}}
X-Trace: smtp01.isdsl.net 1JRuFM-000Pbz-Jc 9ef779872da6cf38edf2fa9c8af68186
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


did someone say interface/API documentation ooops ... <DUCK> seriously
this is lacking and im sure as time goes on some volenteer (sucker) will
get it up and running.this is not a show stoper but a nice to have.ill 
perhaps even help out a bit with things, i have some comments on useage 
and module parameters that could be usefull to the would be 
users.remember mISDN is just the kernel bits there is a user lib that 
takes care of userland bits.

 >
 >> b) still doesn't support all the hardware isdn4linux supports.
 >
 > That's a show stopper of course.

of course not all hardware is supported and in some cases more hardware 
is supported ... there is a precident for this OSS/ALSA where the one is 
  marked as DEPRICATED and the other promoted initialy as EXPERMENTAL ...

over all the most common devices are better supported under mISDN than 
isdn4linux.

and as with OSS/ALSA both can coexist on the system as modules (only one 
can be loaded at a time or else they dont play nice).

i really think this is a storm in a tea cup been blown into a hurricane
after all if it were mainlined (in -mm even) the result would be better 
support and more choice there are far worse supported drivers than the 
mISDN stack.the reality is that isdn4linux is dead idealy unsuported 
drivers need to be ported to mISDN or kept on life support.

--

This message has been scanned for viruses and

dangerous content by Superset Technology, and 

is believed to be clean.

http://www.superset.co.za


