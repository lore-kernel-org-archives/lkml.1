Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbYCCK3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbYCCK3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYCCK3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:29:36 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:5668 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYCCK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:29:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NIRBq9LWnsGrBjRkU/HNlJ21GWzq6mNyCqM77/iff0Yh59oEjFGs3z//iMMYfH/YTK8bB+iUfd7+C62Zr57KGO0+rpO5542W4Yede1ti+kglEDS87x0LWw+DxUw4RMz+8FIFdQyc9icFq5VUmHlHi1+9sHyDxaqd1ZbZF0KzXwE=
Message-ID: <47CBD307.2070603@gmail.com>
Date: Mon, 03 Mar 2008 19:29:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, crmafra2@gmail.com,
       linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       jens.axboe@oracle.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
References: <20080302233415.GA6258@Pilar>	<18379.18297.838050.536473@harpo.it.uu.se>	<tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>	<20080303172641Z.fujita.tomonori@lab.ntt.co.jp>	<47CBC014.9090309@s5r6.in-berlin.de>	<18379.51360.744676.894510@harpo.it.uu.se> <18379.53492.171481.255371@harpo.it.uu.se>
In-Reply-To: <18379.53492.171481.255371@harpo.it.uu.se>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Mikael Pettersson writes:
>  > Stefan Richter writes:
>  >  > FUJITA Tomonori wrote:
>  >  > > On Mon, 3 Mar 2008 02:48:23 +0100 (CET)
>  >  > > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>  >  > >> CD burning still fails for me via ide-cd, although in a
>  >  > >> different way than without the patch.  (Without the patch, ide-cd also
>  >  > >> fails like described by you for SATA.)
>  >  > >>
>  >  > >> With the patch, the failure is as follows.  I don't know if this is
>  >  > >> related to the data length arithmetic or something entirely different;
>  >  > >> all I learned so far is that 2.6.24 works.  Application log from
>  >  > >> 2.6.25-rc3 + Tejun's patch + Gentoo's cdrkit-1.1.6 + k3b:
>  >  > > 
>  >  > > Can you try the following patch?
>  >  > > 
>  >  > > http://lkml.org/lkml/2008/3/2/218
>  >  > 
>  >  > Fails just like with Tejun's patch, alas.
>  > 
>  > At this point I must confess I feel very uneasy about this situation.
>  > 
>  > Dare I suggest the perhaps hereditary solution of reverting these
>  > changes and doing them right after 2.6.25 final?
> 
> Doh! s/hereditary/heretical/

Please lemme track down a bit deeper.  I can reproduce seemingly similar
problem here.

Thanks.

-- 
tejun
