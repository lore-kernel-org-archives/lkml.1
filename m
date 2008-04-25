Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYDYKtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYDYKtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYDYKtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:49:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:2082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYDYKtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=w3klA2kP3iYg4XCrE/AfHklXfHjlOJkBZLdZha5/xMiubIlWqOb0N65ZRhfnU4DnbWMmOR4Ak7Ct8FB3J1Jq/p2rRvBQOVA5Zute4G5pL5qDhNXmSXFGJnpWtGzhHdQv2lUqq523EI0d69cWNEx8lEiKxRSUjycC19/hOFiocCw=
Message-ID: <517f3f820804250349m19efe63eqa789aeb359c86f78@mail.gmail.com>
Date: Fri, 25 Apr 2008 12:49:12 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] socket, socketpair w/flags, accept4
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, "Jakub Jelinek" <jakub@redhat.com>
In-Reply-To: <20080425105835.62e80537@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804241820.m3OIKlMK017580@devserv.devel.redhat.com>
	 <20080425042957.GA17699@2ka.mipt.ru>
	 <517f3f820804242343g22700872tf31f0c15047e70e2@mail.gmail.com>
	 <20080425105835.62e80537@core>
X-Google-Sender-Auth: d562787bf1c58a13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > What about sigset there too?
>  >
>  > Right.  That was what I was understanding that Alan referred to when
>  > he was talking about paccept()
>
>
> Actually I hadn't thought about the sigset at all.

Oh -- okay then.  I had understood that that was what you were
referring to when you mentioned Jakub's reference to paccept() (which
I took to be analogous with pselect() -- I vaguely remember seeing
this discussed elsewhere also).
