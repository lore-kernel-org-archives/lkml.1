Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbYD3KqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbYD3KqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbYD3Kp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:45:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:64420 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbYD3Kp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c8c1RUzNsuEuPDp8XTZWO58LdAasF2eRozm3CDWIqQn5Vcm3g0YrTgciB2ZEnXG6SQVZUCYqljJX/CrFGSYO4H84upBCAPzkj1m2rNZQ0WAyCzTtD7OEoj5EUf98RQI+Ljc+Qyo37bq5VOz7wR4kqRcc6wprnqtSTzmuSpOi/Vk=
Message-ID: <ed10ee420804300345r5d4566d2uff5c3f49f1c15107@mail.gmail.com>
Date: Wed, 30 Apr 2008 03:45:57 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Andres Salomon" <dilinger@queued.net>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@codemonkey.org.uk>,
       "Roland McGrath" <roland@redhat.com>
In-Reply-To: <20080429172402.14d7d40b@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429183531.GB19652@uranus.ravnborg.org>
	 <20080429172402.14d7d40b@ephemeral>
X-Google-Sender-Auth: cd09986b5db33da7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/08, Andres Salomon <dilinger@queued.net> wrote:
> On Tue, 29 Apr 2008 20:35:31 +0200
>  Sam Ravnborg <sam@ravnborg.org> wrote:

>  > And we add support for a new 'commandline' parameter
>  > 'K' so I can say:
>  >
>  > make K=/proc/config.gz defconfig
>  > make K=i386_defconfig  defconfig
>  > make K=i386_defconfig  oldconfig
>  > make K=/proc/config.gz newconfig
>  >
>  > So K is used to specify what config file we use
>  > to start out from.

I like this idea a lot.  I didn't like the hardcoded `.config' 13
years ago and I still
don't like it now.

>  Sounds good, I highly prefer specifying the config via env variable
>  rather than embedded in the target (ie, 'make olpc_defconfig').

Is there any reasonable way to embed the configuration file name in the kernel
image like BSD does it?  /proc/config.gz is a good way to retrieve way to
retrieve configuration information on a running system, not so good for pushing
kernels out to a network and keeping track of the config files on the build
machine.

I don't have any way of checking this now, but can /proc files like
/proc/config.gz
be exported via NFS or the equivalent?

-sb
