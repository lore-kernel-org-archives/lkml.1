Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbXJCLuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbXJCLuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbXJCLuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:50:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:57668 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbXJCLuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eCqQUCc6/bPQAY1Vqkvl6YbfkGMEsvgQwZDLF44nCszfYdCK31yCg/12pTwMYjGg17E9pBCZJBg3QPXbh1fZFNQxb2a07EJNKC5LblyjYHDjqRF+nP838ga7zoumOWLbnBH54Nc6oORrCfUQiWAcArN121y+Nc8ukWAKxVtBO0M=
Message-ID: <3ae72650710030450x16e20473r42c0cee3764646b7@mail.gmail.com>
Date: Wed, 3 Oct 2007 13:50:01 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [mm] Better help needed for UEVENT_HELPER_PATH
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200709281921.24898.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709281921.24898.elendil@planet.nl>
X-Google-Sender-Auth: 1e09690f4d8c4e58
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, Frans Pop <elendil@planet.nl> wrote:
> Current help for CONFIG_UEVENT_HELPER_PATH is:
>    Path to uevent helper program forked by the kernel for
>    every uevent.
> With default value of /sbin/hotplug.
>
> Help! I don't have /sbin/hotplug (Debian unstable, using udev).
> What do I do now? Will my hardware be unsupported because I don't have
> /sbin/hotplug?

Nothing has changed, it's just configurable now for setups which don't
use the "fork-bomb" anymore.

> Should I leave it at the default? Make it empty? Or do I need to replace
> hotplug by some other magic command?

Do nothing, leave it at the default value, if you are unsure about
your setup. If your system works without it, you save a few cycles at
bootup.

> Please extend the help text to give some context and indication of how to
> use this option.

We can't really tell, it entirely depends on the distro, setup, udev
integration, initramfs. Old initramfs setups might need it, even on a
udev system without any /sbin/hotplug like stuff installed. You would
need to look in your initramfs image if it contains a /sbin/hotplug.

Thanks,
Kay
