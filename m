Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZKJVVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZKJVVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZKJVVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:21:46 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50461 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZKJVVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:21:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oPbv0ajdj3HUrTcUP1mP4OdPbtKRHzGvBUsevGZsDer6QNjthxLtR5s6dY55WKdW+4
         wXJ9bCbF19drO3h87+NoKkgaPe4QTHjHdTeC9F525b3DYlQfdKkbGXrG3l5FiaGZjsBY
         5MpKPoOWXIGORFO8w1IqpOvYbR+NNaNYO4kLI=
MIME-Version: 1.0
In-Reply-To: <20091110205445.GB1407@ucw.cz>
References: <20091110052711.GA15338@1wt.eu> <4AF9435F.2070103@redhat.com> 
	<20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> 
	<20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> 
	<4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> 
	<20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz>
From: Matt Thrailkill <matt.thrailkill@gmail.com>
Date: Tue, 10 Nov 2009 13:21:30 -0800
Message-ID: <a91053ef0911101321he1cf15cx8d15d747b371fde4@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Pavel Machek <pavel@ucw.cz>
Cc: Willy Tarreau <w@1wt.eu>, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 12:54 PM, Pavel Machek <pavel@ucw.cz> wrote:
> *One* CMOV in the inner loop will make your performance go down 20x.

This is 20x slower than not running at all, right?
