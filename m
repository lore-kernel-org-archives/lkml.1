Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYDJAh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYDJAh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYDJAhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:37:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:19746 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYDJAhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UfjeXLua190xNhzQRjtdeKo3N/JC3nEVxxmPTimEikze/4Usi4aL6Y4X+YgL+0HTTu2a85rtYe5t/WickOIE5ni/igzqk03iNAOXOM2PoTLRCYEeM9kvkkL3xMmZJqm05+vQTwZWEhFMKbVztL6ZyA+C97JswHJNsvFXST9mIBA=
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mark Lord <lkml@rtr.ca>
Cc: David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
       jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
In-Reply-To: <47FD590C.5020003@rtr.ca>
References: <47FCF9DD.6080007@rtr.ca>
	 <20080410.023045.16227424.yoshfuji@linux-ipv6.org>
	 <47FD138B.2060801@rtr.ca> <20080409.152933.132174258.davem@davemloft.net>
	 <47FD590C.5020003@rtr.ca>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 17:37:28 -0700
Message-Id: <1207787848.16220.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 20:02 -0400, Mark Lord wrote:
> David Miller wrote:
> > From: Mark Lord <lkml@rtr.ca>
> > Date: Wed, 09 Apr 2008 15:05:47 -0400
> > 
> >> But it would be far more useful for whoever has been working on the
> >> stack to suggest some possible/likely commits to look at instead.
> > 
> > Personally all I see is that one side closes the socket before all
> > data packets received have been read into the application, resulting
> > in a (correct) reset going out.
> > 
> > I can't think of any change we've made over the course of this
> > release that would change behvaior in that area.
> > 
> > So you will likely need to bisect.
> ..
> 
> Or I can ignore it, like the net developers, since I have a workaround.
> And then we'll see what other apps are broken upon 2.6.25 final release.
> 
> Really, folks.  Bug reports are intended to *help* the developers,
> not something to be thrown back in their faces.
> 
> There do seem to have been a *lot* of changes around the tcp closing/close
> code (as I see from diff'ing 2.6.24 against latest -git).
> 
> *Somebody* is responsible for those changes.
> That particular *somebody* ought to volunteer some help here,
> reducing the mountain of commits to a big handful or two.
> 

Could you do a poor-man's bisect and test 2.6.25-rc1 and -rc2, that
would probably help a lot to narrow it down.

Harvey

