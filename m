Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXJXEK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXJXEK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXJXEKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:10:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:23475 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXJXEKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Vkov83ELFn5C6ZIA1i2U+1aFCWy0Wcs9qbi7XJ0ehGx35QUmzAYYhHObUrL2RuQPgKy7q/7hfAV5I36wF2q2BUbVqj5RLQnJXVtrMCcHklbvXN/ZvsKvFYda2r9Yc4Ko2Kn7Uyj8rJ/qPp0gfFiN3UoYSIeB1RQpxtg0bs02ZfY=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: New version of Elantech touchpad driver for kernel 2.6.23.1
Date: Wed, 24 Oct 2007 00:10:07 -0400
User-Agent: KMail/1.9.7
Cc: Arjan Opmeer <arjan@opmeer.net>, linux-kernel@vger.kernel.org
References: <20071024035002.GA12026@adopmeer.homeip.net>
In-Reply-To: <20071024035002.GA12026@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710240010.08023.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007, Arjan Opmeer wrote:
> @@ -88,6 +88,7 @@ enum psmouse_type {
>         PSMOUSE_LIFEBOOK,
>         PSMOUSE_TRACKPOINT,
>         PSMOUSE_TOUCHKIT_PS2,
> +       PSMOUSE_ELANTECH,
>         PSMOUSE_CORTRON,
>         PSMOUSE_AUTO            /* This one should always be last */
>  };

Do not move protocol constants around as they are exported to
userspace. New protocols should go to the end of the list
(right in front of PSMOUSE_AUTO).

Thanks. 

-- 
Dmitry
