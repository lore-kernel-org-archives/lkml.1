Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZLDUpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZLDUpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbZLDUpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:45:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50160 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127AbZLDUpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:45:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uWbdIwzweHOuAinkuVLcoAne/Fuej3CfczDqe/oiB5d3QNglxBXfNYeiRtVCAJT8nj
         HUb8QmqQlg52e7Y+N2D8I4h7fXfN7hSkgH4//zPXxJv4ZG5uo1Y+Bu0c3PtdT3t+fIJH
         S2kUhU/l5TpDorJGFUcRRPh7T0318w/hFkVKs=
Date: Fri, 4 Dec 2009 21:44:43 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091204204443.GA2736@ami.dom.local>
References: <20091124111946.GA7883@ff.dom.local>
 <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
 <20091125191105.GA3167@ami.dom.local>
 <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
 <20091127213640.GA2611@ami.dom.local>
 <81bfc67a0911271435g4106652bpe8c9ea07893d0ebd@mail.gmail.com>
 <20091127224206.GA3350@ami.dom.local>
 <81bfc67a0912031749y15faed66s9c8a924684c97a19@mail.gmail.com>
 <20091204090524.GB6478@ff.dom.local>
 <81bfc67a0912041028w16668d0cx4da04bee989eef4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81bfc67a0912041028w16668d0cx4da04bee989eef4a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 01:28:26PM -0500, Caleb Cushing wrote:
> On Fri, Dec 4, 2009 at 4:05 AM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> > If you have it fixed easily with another nic you should first
> > reconsider if this debugging is worth of your time. Of course it's
> > could be very useful for the kernel (unless it's a hardware fault),
> > but on the other hand this is a popular nic, tested by many people.
> 
> trying to figure out if it's hardware, I wish I'd figured that out a
> month ago because dell would have been shipping me a new mobo at that
> point... oh well... I'm starting to think it is but given the age of
> the computer... (just over 1 year now) I'm not happy about that. my
> nic is a 10/100 card the e1000e is obviously gigabit though I don't
> think I've a need (or network) for the gigabit atm

For now there is no proof it's hardware, so don't worry ;-) It might
be firmware, bios etc. And might be kernel too. I meant it's hard to
debug, considering your bisection results, but easy to avoid with
other hardware, so it's up to.

Btw, maybe we(?!) should've done it earlier, but just did some google,
and it looks like these NICs aren't so innocent as I assumed. I'm just
looking here:
https://bugs.launchpad.net/ubuntu/+bug/382671
and there:
http://bugzilla.kernel.org/show_bug.cgi?id=11998
and maybe it's a bit different story, but actors mainly the same.

So, again, if you're willing to debug this, the new bugzilla report
seems reasonable to me, plus maybe some notice to this #11998 too.

Jarek P.
