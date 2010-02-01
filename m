Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0BAJgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:36:45 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:61323 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0BAJgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f+wckANKy3BLStzKD6CAB6IfIN6LqV6y+TqAFe2KG83kBZQoleCpuDcpiWutK+4t2X
         VymUaTOE2xvFTV8dClGIMw/xNVqpz1DYuWgn25d1gYdhO/tNG7fY7bNSPhFQ4wv41QAm
         +89invreVvvzpWehCQ0Bz6P/e3cOz3RiZSc2M=
MIME-Version: 1.0
In-Reply-To: <1265016745.7499.144.camel@tonnant>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>
	 <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
Date: Mon, 1 Feb 2010 11:36:42 +0200
Message-ID: <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
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

On Mon, Feb 1, 2010 at 11:32 AM, Jon Masters <jonathan@jonmasters.org> wrote:
> I hacked up a per-namespace version of hashtables (this needs doing
> anyway, since the global stuff is just waiting to break)

Which ones? Conntrack hashtables are per-netns.
