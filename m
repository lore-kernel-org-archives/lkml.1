Return-Path: <linux-kernel-owner+w=401wt.eu-S1762447AbXLOHJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762447AbXLOHJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXLOHJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:09:38 -0500
Received: from hu-out-0506.google.com ([72.14.214.233]:14473 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbXLOHJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:09:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M39iDsA8ox7WEzMfFnMDBIx2f5mZ5PbIEvaaH+gRpN9vcifPksB1OWqitYbcpCX60HDOdZukf9X/XuQE0HMpkWUicNNRlZVy9T3bRgPSvJbpl92P7obwcXfZu9tma5d9CsacrXAbtNXwa+njTSULh7YvwqryDVXkmhlJjNpexQQ=
Message-ID: <2c0942db0712142309v15f79068m8c033180d41b9be@mail.gmail.com>
Date: Fri, 14 Dec 2007 23:09:35 -0800
From: "Ray Lee" <ray@madrabbit.org>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: Regression: Wireshark sees no packets in 2.6.24-rc3
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47633ECC.3020804@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2c0942db0712131746s7da91f2bkf45b3e1ddf16d1f3@mail.gmail.com>
	 <200712150305.02589.rjw@sisk.pl> <47633ECC.3020804@googlemail.com>
X-Google-Sender-Auth: 9c185fe823e62ed1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 6:41 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Rafael J. Wysocki wrote:
> > On Friday, 14 of December 2007, Ray Lee wrote:
> >> tshark -i eth0, eth1, lo are all empty. Works under 2.6.23.0 just
> >> fine. A quick scan of the log between 2.6.24-rc3 and current tip
> >> (-rc5) doesn't show any obvious fixes, but then again, what do I know.
> >> I'll check current tip on the weekend when I'll have the luxury to
> >> have my main system down long enough for a test. Right now I'm kinda
> >> up against a deadline, but didn't want to leave it unreported. Should
> >> be easy for someone else to confirm or deny whether current tip has
> >> the problem.
> >
> > FYI, I have created a bugzilla entry for this issue at:
> > http://bugzilla.kernel.org/show_bug.cgi?id=9568
>
> Hmm what do you mean by empty ? it does not capturing anything on that interface ?

Correct, absolutely no traffic. So if it works for you, then either
it's something that got fixed between -rc3 and -rc5, or something odd
when I did a make oldconfig, I suppose. (Or because I'm on an x86-64
kernel?) Regardless, -rc5 is currently building, and I'll try it in
the morning.

> I do run -rc5-git with wireshark-0.99.6 and tshark -i eth0 or lo works here.

Excellent. Thank you for checking!

Rafael: I'll update the bugzilla as warranted after testing.

Ray
