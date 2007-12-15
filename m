Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbXLOIQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbXLOIQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 03:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXLOIQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 03:16:37 -0500
Received: from hu-out-0506.google.com ([72.14.214.237]:37306 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbXLOIQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 03:16:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bXVXRwuG06UuR7VDzKTCvBm5guAEQ4I41/+Aa7VDyySTMtbF0VQrgwzEGagxlsOOnmjFzLSQ07WRLz6lK7QBlJ9JrhV03EpnhW53bT6hkslmW8qQJQYm8+kGvJZf0bXhZrxFCs7cSJ4jGGUSsXoyGoJqvylsbW5Vb01cbRRJ2g4=
Message-ID: <2c0942db0712150016r149d285bs8f4e1c444e71afea@mail.gmail.com>
Date: Sat, 15 Dec 2007 00:16:34 -0800
From: "Ray Lee" <ray@madrabbit.org>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: Regression: Wireshark sees no packets in 2.6.24-rc3
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <2c0942db0712142309v15f79068m8c033180d41b9be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2c0942db0712131746s7da91f2bkf45b3e1ddf16d1f3@mail.gmail.com>
	 <200712150305.02589.rjw@sisk.pl> <47633ECC.3020804@googlemail.com>
	 <2c0942db0712142309v15f79068m8c033180d41b9be@mail.gmail.com>
X-Google-Sender-Auth: 80a86c281f56072a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 11:09 PM, Ray Lee <ray@madrabbit.org> wrote:
> On Dec 14, 2007 6:41 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Correct, absolutely no traffic. So if it works for you, then either
> it's something that got fixed between -rc3 and -rc5, or something odd
> when I did a make oldconfig, I suppose. (Or because I'm on an x86-64
> kernel?) Regardless, -rc5 is currently building, and I'll try it in
> the morning.

-rc5 works great. Really don't know what's different between my -rc3
and -rc5 builds. The diff of .config between the two doesn't show
anything obvious, so perhaps it was something fixed in the interim.

I've gone ahead and closed the bugzilla entry, btw. Thanks, and sorry
for the false (or tardy) alarm.

Ray
