Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0BAKtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:49:55 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:44544 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab0BAKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:49:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=x+Tu7ALniL5Ow0w3JprJS8stssWDCi40rYIGisRNP+mRnERYOWMNBz6leUV8PWx63I
         NowgOZsWodobEvQaH2EUUxZoL3ct/gRjvBo5cHNij0ZrrEMuTowfFa/ZHjgRB+85o/OU
         h9uVFj/Pibq7Wu4W+OJbX+th/2AuEMzgE2bHM=
MIME-Version: 1.0
In-Reply-To: <b6fcc0a1002010247s70b855b6kea66c99c9326b6a@mail.gmail.com>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>
	 <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265020552.7499.147.camel@tonnant>
	 <b6fcc0a1002010244j161f7f0bob46053efc0d65630@mail.gmail.com>
	 <b6fcc0a1002010247s70b855b6kea66c99c9326b6a@mail.gmail.com>
Date: Mon, 1 Feb 2010 12:49:52 +0200
Message-ID: <b6fcc0a1002010249y19e2edc3g7974f44633859bd3@mail.gmail.com>
Subject: Re: debug: nt_conntrack and KVM crash
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 12:47 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> Or even printk nf_conntrack_htable_size during bootup and panic/oops.

Oh, sorry, I see it was indeed corrupted.
