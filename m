Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYDYGnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYDYGnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYDYGnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:43:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:20757 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYDYGnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FozLKcZ29/AOBkuQduJyHEgeQAeFc4HspHvtlI45QR1l8cFM2GM+yhCRi4pV30+YulZoDA/g1/Awyx5lJqwfqwD2wtSE5fQ853uergK6c8uOM82AsNRHSU2L8dmUg+g95afc0ByJeKkGYxmnXwWrOvDfa34ejYrWTK2z7dDU6C4=
Message-ID: <517f3f820804242343g22700872tf31f0c15047e70e2@mail.gmail.com>
Date: Fri, 25 Apr 2008 08:43:05 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] socket, socketpair w/flags, accept4
Cc: "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jakub Jelinek" <jakub@redhat.com>
In-Reply-To: <20080425042957.GA17699@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804241820.m3OIKlMK017580@devserv.devel.redhat.com>
	 <20080425042957.GA17699@2ka.mipt.ru>
X-Google-Sender-Auth: e240ef840d17f12b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/08, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Hi.
>
>
>  On Thu, Apr 24, 2008 at 02:20:47PM -0400, Ulrich Drepper (drepper@redhat.com) wrote:
>  > The code changes are really minimal.  And don't get too hung up on the
>  > internal name of the syscall.  I think accept4 is more desriptive than
>  > paccept since a) suffixes more easily indicate derived functionality
>  > and b) the 4 actually indicates to the initiated what has changed.
>  > If there are good reasons otherwise the userlevel interface can still
>  > be something completely different.
>
>
> What about sigset there too?

Right.  That was what I was understanding that Alan referred to when
he was talking about paccept()
