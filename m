Return-Path: <linux-kernel-owner+w=401wt.eu-S934416AbZIDWdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbZIDWdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934366AbZIDWdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:33:16 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60535 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934334AbZIDWdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fQd4k3R0QIsLqHk3n2JlmgFIvqqgzrCpwrmc9JuC1ib6186pZM0d5tDklKtdOrEzhC
         JjgZKxLk/PTqp6M/KeYdpksQKQr4tMZS9KCoAJbBf4g2CwM5ztXLzsnPXBzbOa0RI4VU
         ehD6fkxcQBAohwIwwpoVg7ir/6/8ANR9ld8no=
Subject: Re: 2.6.31-rc5 regression: hd don't show up
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Tim Blechmann <tim@klingt.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <4AA18F57.8030107@klingt.org>
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org>
	 <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org>
	 <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org>
	 <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org>
	 <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org>
	 <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org>
	 <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org>
	 <4AA18F57.8030107@klingt.org>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 01:33:09 +0300
Message-Id: <1252103589.10901.14.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 00:06 +0200, Tim Blechmann wrote:
> >>>>>> booting the machine today, one hd is missing again ... bootlog attached
> >>>>> Hmmm... strange.  I don't really see how it could be escaping.  Can
> >>>>> you please apply the attached patch?  It still won't change the
> >>>>> behavior but should be able to catch where it's escaping.
> >>>> attached you find two bootlogs, for a correct boot, and with one hd
> >>>> missing ...
> >>> Heh heh, this is getting a bit embarrassing.  Seems like I wasn't
> >>> looking at the right path.  Can you please try this one too?  If it
> >>> says "XXX D7 pulldown quick exit path" and then succeed to probe,
> >>> that's the previous failure case so you don't need to keep trying to
> >>> reproduce the problem.
> >>
> >> i've attached the two boot logs again ...
> > 
> > Okay, it was another wrong guess.  Can you please try this one?
> 
> unfortunately, i haven't been able to get a bootlog of a failure the
> issue after rebooting like 20 times with yesterday's linus/master.
> once i couldn't boot, since the root hd wasn't found, so i don't think,
> the issue is solved, it just doesn't show very frequently ...
> 
> the bootlog of a working system is attached, if i experience another
> issue, i will send you another bootlog. since i am out of town for a few
> days, it may take some time, though ...
> 
> tim
> 

Note, that I did see this once on my desktop, few weeks ago, but only
once.
(After a reboot, everything did work fine)

Best regards,
	Maxim Levitsky

