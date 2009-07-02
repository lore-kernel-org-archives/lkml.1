Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZGBLJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZGBLJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZGBLJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:09:44 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:42103 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZGBLJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=smnefIZyBYzmok+ZHww5iaNRT+e1IXdInwGeNOx7wQbYHskGNi27przXYeu1rP1vRG
         zft55PSKrXmJeZtKuNlPRu4y2ksU5TcdUI1E1o8YAf+z4yC1FSHbcHxF0yKamJB1nfTZ
         f4AvsVI6Ba6aEV+AZ04oOSeAUQBOWFwMeuFUw=
Date: Thu, 2 Jul 2009 11:09:40 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, Andres Freund <andres@anarazel.de>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (possibly
	caused by netem)
Message-ID: <20090702110940.GA7402@ff.dom.local>
References: <4A4A9DD6.8060800@anarazel.de> <4A4BAD5F.7050908@gmail.com> <4A4BD384.3090407@anarazel.de> <4A4C0144.5070203@anarazel.de> <20090702093031.GC4954@ff.dom.local> <20090702101207.GA7056@ff.dom.local> <a5d9929e0907020351u4e441486nf285ac6cb32c3202@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d9929e0907020351u4e441486nf285ac6cb32c3202@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 11:51:56AM +0100, Joao Correia wrote:
> Im getting this one too. On any .31-rc1-gitXX, it pops up a few
> seconds after i turn traffic shaping on with tc/htb (no netem here).
> Its easily reproducible on my end, turn on traffic shaping, get
> traffic flowing, box freezes. No error message, nothing on logs,
> although -sometimes- i get lockdep error messages on screen, but
> scrolls too fast and box is otherwise unresponsive, so i can't get the
> error out.
> 
> This does not happen on 2.6.30 at all.
> 
> Hope this helps.
> 
> (i tried both CONFIG_PACKET_MMAP off and the patch, still happens).

It helps for sure - to save on useless checking, and maybe reproduce
too.

Thank you very much Joao,
Jarek P.
