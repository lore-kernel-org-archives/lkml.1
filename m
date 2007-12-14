Return-Path: <linux-kernel-owner+w=401wt.eu-S1764976AbXLNQ2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764976AbXLNQ2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXLNQ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:27:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:35566 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbXLNQ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:27:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pTXhMM83BgcKTZDuQqoS3BU8WHMh7Bh3eiCLSraiZaN6orZdg/BU6mMcS+J7o/asAmGzXjICW+OVnX4GKAiw70I/scFP1ylANr0uJ5/e+sfr/ACTVNlIwmjAhmijfqpyDIAJpkTdF7P96kyJ76fLuQhXlH2i4WazuCMj4oW6Gns=
Message-ID: <2c0942db0712140827x38e5d971sbdb3d5864fc32364@mail.gmail.com>
Date: Fri, 14 Dec 2007 08:27:53 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: stefano.brivio@polimi.it
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "John W. Linville" <linville@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Walker" <dwalker@mvista.com>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, mbuesch@freenet.de, linux@bohmer.net,
       "Michael Buesch" <mb@bu3sch.de>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <20071214154022.v5w0eqwwiogws8cw@webmail.polimi.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712131445.39770.mb@bu3sch.de>
	 <2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com>
	 <200712140143.16451.mb@bu3sch.de> <20071214105624.GC23964@elte.hu>
	 <20071214141446.GA3096@tuxdriver.com>
	 <20071214154022.v5w0eqwwiogws8cw@webmail.polimi.it>
X-Google-Sender-Auth: d235b7b02270ff7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 6:40 AM,  <stefano.brivio@polimi.it> wrote:
> Agreed. As a b43legacy maintainer, I'd be happy to know if Ingo
> suggests other ways to smooth out the transition. I haven't read
> proposals yet.

This isn't rocket science guys. Put a file in somewhere in your tree
called ReleaseAnnouncement or something, and ask Linus to adjust his
kernel release process to include the contents of `cat $( find . -name
ReleaseAnnouncement )` in the release message he sends out. Clear out
the file after the release.

Include things such as "bcm43xx is scheduled for removal. build both
b43 and b43legacy as a replacement. Be sure to download the latest
firmware from $URL and follow the instructions there to extract the
correct latest firmware necessary for your chip. There are known
incompatibilities with old udev versions, please ensure blah blah
blah."

Ray
