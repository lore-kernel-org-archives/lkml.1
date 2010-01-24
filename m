Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615Ab0AXDm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0AXDm2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 22:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294Ab0AXDm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 22:42:26 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:47733 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab0AXDmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 22:42:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DRvhQhfcXcQ1MaxShl0h2GZ1HzCRrpzWpgixDq5lA+0AaB3qc4o/4KwnKE5un2MPwW
         557c2AsplbDyrvTAIsRJvfaog6Bsnr5ISR6EYP55qzta6rOIPlkEXuGH4PHQIDAXwUAL
         v4jyaz8zMq9J5bq0XzHighOCJhCGwnBuyIFtQ=
MIME-Version: 1.0
In-Reply-To: <4B5B0B10.2000009@gmail.com>
References: <20100120171901.b2e06465.sfr@canb.auug.org.au>
	 <b9df5fa11001202022q22c2d81cs5b90f694be37c1f4@mail.gmail.com>
	 <20100121230331.GA29796@kroah.com>
	 <b9df5fa11001230453k4a874ebamff02b64f7d6fcd84@mail.gmail.com>
	 <4B5B0B10.2000009@gmail.com>
Date: Sun, 24 Jan 2010 09:42:23 +0600
Message-ID: <b9df5fa11001231942y2703e825k8b46b6aebaef38a0@mail.gmail.com>
Subject: Re: linux-next: tty tree build warning
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/10, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 01/23/2010 01:53 PM, Rakib Mullick wrote:
>
> Why not just param_array(int) instead of whole parsing in ip2_setup?
>
Parameter is passed as strings and current ip2_setup deals with strings.
And using param_string() we can do it at minimum change. Just trying to make
sure that if ip2 parameter is passed at module load then we are
calling ip2_setup.

thanks,
>  --
>
> js
>
