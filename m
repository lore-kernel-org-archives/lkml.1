Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbYBUWvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbYBUWvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYBUWvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:51:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:5046 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYBUWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:51:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=GZbHran+TsG55IatcT7myr/tHek/dzLyhpvfMupTCeeV4XKJza0z2ayI6HesWyvWKY/+E6ylwprD79sz8Qukipc6lMsVeMokq0LNEj2vMPrbqmvWd3JIe8I0y4Zz01hMUI8XHBQNQNLsZS5UVwT8bhnTUmm0ZKpNgsXPdGmyvIE=
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
Date: Thu, 21 Feb 2008 23:51:11 +0100
User-Agent: KMail/1.9.7
Cc: Chris Vine <chris@cvine.freeserve.co.uk>, Dan Williams <dcbw@redhat.com>,
       chris2553@googlemail.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802212251.26897.IvDoorn@gmail.com> <1203633991.3186.2.camel@boulder.homenet>
In-Reply-To: <1203633991.3186.2.camel@boulder.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802212351.12637.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008, Chris Vine wrote:
> On Thu, 2008-02-21 at 22:51 +0100, Ivo van Doorn wrote:
> > On Thursday 21 February 2008, Chris Vine wrote:
> [snip] 
> > > Here's some further information.
> > > 
> > > I have a fully functioning version of rt2x00-2.0.14 and mac80211 from
> > > wireless-2.6/compat-wireless-2.6 of mid January which works fine on
> > > kernel 2.6.24.  On doing a comparison with the rt2x00 in vanilla kernel
> > > 2.6.25-rc2, there are no material differences.  (There was a slight
> > > change in the declaration a variable in rt2x00usb.c but it is
> > > immaterial.)
> > > 
> > > I compiled up the working mid-January version of rt2x00 and mac80211
> > > under kernel 2.6.25-rc2 and I get exactly the same result as I reported
> > > earlier, namely I get a kernel panic as soon as I try to associate.  It
> > > looks therefore as if something has changed within the remainder of the
> > > kernel which has caused rt2x00 (and possibly mac80211?) to break.
> > > 
> > > This probably explains the problem another user reported with rt61.
> > 
> > Perhaps something similar like:
> > http://bugzilla.kernel.org/show_bug.cgi?id=10058
> > in there a reference is made to the following patch:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/broken-out/revert-send-a-single-notification-on-device-state-changes.patch
> > 
> > Does applying that help?
> 
> Yes, well done.
> 
> I have spent 20 minutes testing it and it seems to work fine (at least
> as well as 2.0.14 does under kernel 2.6.24).  The rate control algorithm
> seems to work better as well, but that is probably a mac80211 thing.

Excellent, I am currently updating rt2x00.git from wireless-testing to get
the above mentioned patch into the repository.

Ivo

