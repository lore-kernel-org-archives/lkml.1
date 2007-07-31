Return-Path: <linux-kernel-owner+w=401wt.eu-S1764189AbXGaN1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764189AbXGaN1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbXGaN0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:26:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:35106 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbXGaN0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jnusnz6grppk9cOmMTGchWTTpqSD1asVipJEJGYm++o+Jb4aRBsr/G7Y4UXgINka3WuVNCCLkQpALGDfxlipqct/Ngx4MTov14dRs2QyAL5lW/vn3Sd1t6WsICqN3UPxJksaSmZMI9oggJ95PWARB+01EHICMM6LqYxs8J/z65c=
Message-ID: <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com>
Date: Tue, 31 Jul 2007 22:26:48 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Satyam Sharma" <satyam@infradead.org>
Subject: Re: Crypto API Weirdnesses
Cc: "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       linux-kernel@vger.kernel.org,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-crypto@vger.kernel.org, dm-devel@redhat.com
In-Reply-To: <alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430707301336v37bc7433jed09451ab60ad89a@mail.gmail.com>
	 <alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > "Failed to setup dm-crypt key mapping.
> > Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and
> > verify that /dev/hda4 contains at least 133 sectors.
> > Failed to read from key storage"
>
> Looks like a "cryptsetup" error message, not kernel's.

I can't find CONFIG_DM_CRYPT in the .config.
Maybe cryptsetup needs it.

We should improve cryptsetup error message.
