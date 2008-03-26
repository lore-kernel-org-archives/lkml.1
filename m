Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYCZObZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYCZObZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYCZObS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:31:18 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:29023 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYCZObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:31:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SNA3J4HXKS90O97JZgx+zt6CW5sN6n8fAcpCZavlObY2H9DnhAjCgaiwNOVxeo7FZ6oESLbAD9Ln355txb/F79rnxGY0VGfIfO7WUaojY3ez1H3NRt2sPRX0WOQm1bTg9j80QpRnVjN+Mxocpap5pee/ZiAbw01nPYzm3M4yBs4=
Message-ID: <8bd0f97a0803260731x4378c71q1e2e5598c1728e1d@mail.gmail.com>
Date: Wed, 26 Mar 2008 10:31:15 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] [Blackfin try #2] char driver for Blackfin on-chip OTP memory
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       "Wim Van Sebroeck" <wim@iguana.be>, "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <47EA268F.8070006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206580131-22527-1-git-send-email-cooloney@kernel.org>
	 <47EA268F.8070006@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 6:33 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 03/27/2008 02:08 AM, Bryan Wu wrote:
>  > From: Mike Frysinger <vapier.adi@gmail.com>
> > +static int __init bfin_otp_init(void)
>  > +{
>  > +     int ret;
>  > +
>  > +     stampit();
>  > +
>  > +     ret = misc_register(&bfin_otp_misc_device);
>  > +     if (ret) {
>  > +             pr_init(KERN_ERR PFX "unable to register a misc device\n");
>  > +             return ret;
>  > +     }
>  > +
>  > +     pr_init(KERN_INFO PFX "initialized\n");
>
>  except the fact, that pr_init definition seems to be broken. Its defined __fmt
>  is const, so it should reside in .init.rodata (__initconst), not .init.data
>  (__initdata).

i dont see an __initconst macro anywhere ?

also, it isnt "broken" in the sense that it "doesnt work" ;)
-mike
