Return-Path: <linux-kernel-owner+w=401wt.eu-S1763982AbXLMTH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763982AbXLMTH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXLMTHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:07:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:15311 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbXLMTHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:07:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uc1vq4tiCOZ+Lge78RRrcLOe91G2kvLkO8/V8D6Ff0TTR/9uvqyOh8PAXuM1o+aWwE63B8sYfHmUXl9MNR44pX00VZJm1yQhDK+H6o0ry9z9Mk8HImNZYCj1TLTfbDPQyNPj+963ArJnBP+MGtPd752C/K53LM8CcKiQL+GT0rI=
Message-ID: <6101e8c40712131107r23cda32p86d2a3e22a3adcb8@mail.gmail.com>
Date: Thu, 13 Dec 2007 20:07:16 +0100
From: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>
Subject: Re: [patch 32/36] XFS: Make xfsbufd threads freezable
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "David Chinner" <dgc@sgi.com>,
       "Lachlan McIlroy" <lachlan@sgi.com>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B001520239@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20071213062511.265908583@mini.kroah.org>
	 <20071213063529.GG25301@kroah.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B001520239@ecqcmtlmail3.quebec.int.ec.gc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://lwn.net/Articles/235908/

On 12/13/07, Fortier,Vincent [Montreal] <Vincent.Fortier1@ec.gc.ca> wrote:
> > -----Message d'origine-----
> > De : linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] De la part de Greg KH
> > Envoyé : 13 décembre 2007 01:35
> >
> > 2.6.22-stable review patch.  If anyone has any objections,
> > please let us know.
> >
> > ------------------
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > patch 978c7b2ff49597ab76ff7529a933bd366941ac25 in mainline
> >
> > Fix breakage caused by commit 831441862956fffa17b9801db37e6ea1650b0f69
> > that did not introduce the necessary call to set_freezable()
> > in xfs/linux-2.6/xfs_buf.c .
> >
> > SGI-PV: 974224
> > SGI-Modid: xfs-linux-melb:xfs-kern:30203a
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Signed-off-by: David Chinner <dgc@sgi.com>
> > Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> > Cc: Oliver Pintr <oliver.pntr@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > ---
>
> Hi Greg,
>
> Don't know if it is related but I got this while building on Debian Etch
> 4.0:
>   Building modules, stage 2.
>   MODPOST 1882 modules
> ERROR: "set_freezable" [fs/xfs/xfs.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make[1]: Leaving directory
> `/usr/src/linux-headers-2.6.22.15-rc1-cfs-etch-686-envcan'
> make: *** [debian/stamp-build-kernel] Error 2
>
> - vin
>


-- 
Thanks,
Oliver
