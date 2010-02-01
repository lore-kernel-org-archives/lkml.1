Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0BAO5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:57:15 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:47171 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0BAO5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:57:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FqXPgn4UOUQYN+dmQAW/bIYfMQtHifIIhlQbC12T11Xmu49706bZ6o91czuoLQzSeo
         OJ6PEk/w6xwUgKdhwzk7Wg+x1XdoS5a3LeCyOsMhhDGRQubADsHiDOJOcsdkpB6HZXwb
         S+YBOvBZ4T9+pS9SrT9IV/2Ds3XyCsE0tU6oo=
Subject: Re: debug: nt_conntrack and KVM crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <b6fcc0a1002010648k5a27c2dey12c1cdcb0790a33@mail.gmail.com>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant> <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265019160.2848.14.camel@edumazet-laptop>
	 <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
	 <1265023437.2848.30.camel@edumazet-laptop>
	 <b6fcc0a1002010648k5a27c2dey12c1cdcb0790a33@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 15:57:07 +0100
Message-ID: <1265036227.2848.53.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 février 2010 à 16:48 +0200, Alexey Dobriyan a écrit :

> conntracks also have netns pointer (->ct_net). This should be enough, yes?
> 

Not checked in __nf_conntrack_find() and other lookup routines/helpers
(nf_ct_tuple_equal(), ...)




