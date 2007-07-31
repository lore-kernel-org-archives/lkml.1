Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbXGaNnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbXGaNnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXGaNnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:43:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:36455 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbXGaNnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Lpsy/d5OIo/nf+MZ8BAeFb5A2zfBniPpGEh1gxH1Uq5JCLhn0a2DceXCSNcoraJXD23+vmj9A1t24r+ZrgKWlbyHDDjRIWlt7mv0sI0Z7mcIu5jB9+mKvLnJvFXwd/qFYNQWPvtsNe3B34DDmFLZfJoWyHa2uXvdK1bAlVf+un0=
Message-ID: <31e679430707310643h670ffb1bg852f0e14eafa11a9@mail.gmail.com>
Date: Tue, 31 Jul 2007 09:43:10 -0400
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Satyam Sharma" <satyam@infradead.org>
Subject: Re: Crypto API Weirdnesses
Cc: "Akinobu Mita" <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-crypto@vger.kernel.org, dm-devel@redhat.com
In-Reply-To: <alpine.LFD.0.999.0707311916150.26032@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430707301336v37bc7433jed09451ab60ad89a@mail.gmail.com>
	 <alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in>
	 <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com>
	 <31e679430707310632u52f43fefg8313143953ccb9b3@mail.gmail.com>
	 <alpine.LFD.0.999.0707311916150.26032@enigma.security.iitk.ac.in>
X-Google-Sender-Auth: df0e64ed62032ef7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Satyam Sharma <satyam@infradead.org> wrote:
> Hi,
>
>
> On Tue, 31 Jul 2007, Felipe Balbi wrote:
>
> > On 7/31/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > > > > "Failed to setup dm-crypt key mapping.
> > > > > Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and
> > > > > verify that /dev/hda4 contains at least 133 sectors.
> > > > > Failed to read from key storage"
> > > >
> > > > Looks like a "cryptsetup" error message, not kernel's.
> > >
> > > I can't find CONFIG_DM_CRYPT in the .config.
> > > Maybe cryptsetup needs it.
> >
> > yeah... it was that... working ;-)
>
> Ugh, you should at least be checking if you've built the kernel with the
> same config options :-) Of course, if you did a simple "make oldconfig"
> but still lost some config options, then that's definitely a regression...
> (was that the case here, btw?)

yeah... I was make oldconfig'ing :-p

>
>
> > btw... why DM_CRYPT is below "Multi-Devices" menu and not in
> > "Cryptographic Options"?
>
> Well, DM_CRYPT /is/ a device-mapper target first. "Cryptographic options"
> is for _actual_ crypto code, such as algorithm implementations etc. Users
> such as encrypting file systems / IPsec / dm-crypt are better off at their
> logical places, I'd say.

Hmmm... ok... thanks for the clarification ;-)

>
>
> Satyam
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
