Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0BBR6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:58:52 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:46303 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0BBR6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:58:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ne+z+V8u6fujoT8l8FnAHY9Jp+gSuh5OIde+HVJkr+ngxn2kLIboAExMkatk/GvU+C
         uue5JJGPRdh2GskXJ0v0gFeI+Bf2hfO+UAu48Jah6xqooO6m9icZzs2IX0L9uUEERpQF
         fsWicXi7bTPAw4nCm8TT2lW8QSrjibx2OP4LU=
MIME-Version: 1.0
In-Reply-To: <1265130426.2861.158.camel@tonnant>
References: <1264813832.2793.446.camel@tonnant>
	 <1265023437.2848.30.camel@edumazet-laptop>
	 <1265035970.2848.50.camel@edumazet-laptop>
	 <b6fcc0a1002010658j4f52a9b8kf10e4bb07a2f1075@mail.gmail.com>
	 <1265036548.2848.55.camel@edumazet-laptop>
	 <1265108690.2861.118.camel@tonnant>
	 <1265110504.2861.135.camel@tonnant>
	 <1265129192.2861.141.camel@tonnant> <4B685756.8010107@trash.net>
	 <1265130426.2861.158.camel@tonnant>
Date: Tue, 2 Feb 2010 19:58:46 +0200
Message-ID: <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com>
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 7:07 PM, Jon Masters <jonathan@jonmasters.org> wrote:
> No problem. And thanks for your help. I'm sorry if I sound frustrated at
> this, it's just causing all of my test machines running KVM guests to
> fall over :)

So it's my bug either way. :-(
Yes, moving to init_net-only function is fine.
