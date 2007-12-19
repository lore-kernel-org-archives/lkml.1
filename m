Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbXLSQxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbXLSQxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXLSQxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:53:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:51050 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbXLSQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:53:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ue5hbY1YMXY7H0gT+OnY0lMHcDhAKCvfQOfTCikrQfhCiF0nzFYCsy6TF9kPXKCHhOu3hjuxU1wZ7DjuNYZrW34aga5P50ZoxVywpzgsFjKB0l0poyokdOw4Ymcfy34nBu3iXzWXC3Y8yBGLRL+wovyH2wRrVqHvVxWIiP6A26E=
Message-ID: <83a51e120712190853q33d9c7c1t4a46380665b7538b@mail.gmail.com>
Date: Wed, 19 Dec 2007 11:53:06 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       "Linux Netdev List" <netdev@vger.kernel.org>
In-Reply-To: <47682F8C.20205@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
	 <Pine.LNX.4.64.0712181704380.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712180845k6cadf67bn5dd66fb2d3ac72d4@mail.gmail.com>
	 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>
	 <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
	 <4768123A.7040603@cosmosbay.com>
	 <83a51e120712181144l65633b32r72cc369f9d012f47@mail.gmail.com>
	 <47682F8C.20205@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So you see outgoing SYN packets, but no SYN replies coming from the remote
> peer ?  (you mention ACKS, but the first packet received from the remote
>  peer should be a SYN+ACK),

Right, I meant to say SYN+ACK.  I don't see them coming back.


> When the problem comes, instead of restarting the application, please take a
> tcpdump of say 10.000 packets.
> Then turn off tcp_sack and take a 2nd tcpdump sample, and make both samples
> available to us.

I can take these captures and take a look at the results.
Unfortunately, I don't think I'll be able to make the captures
available to the general public.



> If turning off tcp_sack makes the problem go away, why dont you turn it off
> all the time ?

Unfortunately, I think that will be the answer if I can't get any help
fixing this problem in the kernel.  It's a bummer, because many of the
remote hosts my application communicates with are on wireless links,
so there may be performance implications to turning SACK off.
