Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbXGaNcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbXGaNcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXGaNcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:32:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:63908 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927AbXGaNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YLnCIWfKECD3DHoSiqA0BgWVKamJxsFF0gpdao6RwiiCWnwF4cWRzh5oOM4EfEx6MdQXGiNHsOyvYWOIPsT/SKPn9bSCnjWPLq9ZO2ekF/izsvMMrGlgD1mkgvSfxhGbEoaBNe1At1P6VWSDXSNww0/jTUk71sgE7icu6/+0C6w=
Message-ID: <31e679430707310632u52f43fefg8313143953ccb9b3@mail.gmail.com>
Date: Tue, 31 Jul 2007 09:32:08 -0400
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: Crypto API Weirdnesses
Cc: "Satyam Sharma" <satyam@infradead.org>, linux-kernel@vger.kernel.org,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-crypto@vger.kernel.org, dm-devel@redhat.com
In-Reply-To: <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430707301336v37bc7433jed09451ab60ad89a@mail.gmail.com>
	 <alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in>
	 <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com>
X-Google-Sender-Auth: a16c6684c2b96008
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > > "Failed to setup dm-crypt key mapping.
> > > Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and
> > > verify that /dev/hda4 contains at least 133 sectors.
> > > Failed to read from key storage"
> >
> > Looks like a "cryptsetup" error message, not kernel's.
>
> I can't find CONFIG_DM_CRYPT in the .config.
> Maybe cryptsetup needs it.

yeah... it was that... working ;-)

btw... why DM_CRYPT is below "Multi-Devices" menu and not in
"Cryptographic Options"?



>
> We should improve cryptsetup error message.
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
