Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYKFVSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYKFVSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYKFVRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:17:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:28247 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYKFVRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:17:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IcJvZ1bsawPCvhjZ9PKziwbRhOk6OgoK3DgFE83yMUBtiGbOeFNUb6bMQmQBiC+XWU
         Fks2qbw8vunPdF1gzjWLEfXBbx6wMl/x7VOzrw6jynG8pwaNSq8TvaZLXVpXmPpTtTjF
         C0ujYagvHfqa/rn8wZqlDczZ+KxeNX8FfSJBU=
Message-ID: <8bd0f97a0811061317v53fa6faau9832d1869cf888f6@mail.gmail.com>
Date: Thu, 6 Nov 2008 16:17:50 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: introduce KECHO convenience echo
Cc: "Mike Frysinger" <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
In-Reply-To: <20081106205048.GA2972@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225960295-30366-1-git-send-email-vapier@gentoo.org>
	 <20081106205048.GA2972@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 15:50, Sam Ravnborg wrote:
> On Thu, Nov 06, 2008 at 03:31:34AM -0500, Mike Frysinger wrote:
>> There is a bunch of places in the build system where we do 'echo' to show
>> some nice status lines.  This means we still get output when running in
>> silent mode.  So declare a new KECHO variable that only does 'echo' when we
>> are in a suitable verbose build mode.
>
> Nice idea.
> I will add it as soon as I start working on kbuild-next
> Same for your other two patches.
>
> A lot of the kbuild stuff today is using lowercase to
> avoid all the typical SCREAMING in Makefiles so I
> may end up using $(kecho).

yeah i wasnt sure whether to use $(KECHO) or $(kecho) or just $(echo).
 i'm really not partial to any :).
-mike
