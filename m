Return-Path: <linux-kernel-owner+w=401wt.eu-S935287AbYBGXeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935287AbYBGXeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbYBGXd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:33:59 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:57869 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758208AbYBGXd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:33:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ny9mEmW3+3TmwvqNZ4uyDpCs3186PnOjcC+BRyzuecJ3uh6YR5S7GYv1Xqrh4vHjXsL9sYJ5XPPoYWn9Ai1ZxGu1NclJFccctyE/UTnPnglBlx5EBmmvMVLTclOYEZZMs7rTYS2UTK9a0VlMIP501OMUXk7Gr5OW1hWs+qkpdJg=
Message-ID: <2c0942db0802071533l5c3b98fel90946b73f8a9586b@mail.gmail.com>
Date: Thu, 7 Feb 2008 15:33:54 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Carlos Corbacho" <carlos@strangeworlds.co.uk>
Subject: Re: ACPI_WMI: worst config description of all times
Cc: "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <lenb@kernel.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200802072318.28313.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080207214715.GA15211@elf.ucw.cz>
	 <200802071727.38743.lenb@kernel.org>
	 <20080207223455.GB6096@elf.ucw.cz>
	 <200802072318.28313.carlos@strangeworlds.co.uk>
X-Google-Sender-Auth: 39a6ac660e6e1f24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 3:18 PM, Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:
> As for the Kconfig - I'm open to suggestions.

While the kconfig text is supposed to say 'what' something is, the
more valuable piece of information it provides is *why* one would want
to enable it.

Do you have list of hardware/platforms that require this feature to
get the hardware to work? (acer abc123, tcm1100 xyz) If so, providing
that information to the user/distributions is the right first step.
Tell them why they want this feature.

Better, if there are kernel drivers that require this (and currently
only those drivers), then have those kernel drivers enable ACPI WMI,
and otherwise leave it off. If/when the userspace accessible bits go
in, it can be exposed to the configurator then.

Ray
