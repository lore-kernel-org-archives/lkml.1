Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZJCSSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZJCSSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 14:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZJCSSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 14:18:24 -0400
Received: from vbn.0050556.lodgenet.net ([216.142.194.234]:34365 "EHLO
	vbn.0050556.lodgenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbZJCSSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 14:18:23 -0400
Subject: Re: [PATCH] LED driver for Intel NAS SS4200 series (v5)
From: Richard Purdie <rpurdie@rpsys.net>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>, rgirod@confocus.com,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1254437012-9783-1-git-send-email-dave@sr71.net>
References: <1254437012-9783-1-git-send-email-dave@sr71.net>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 17:57:23 +0100
Message-Id: <1254589043.19472.0.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 15:43 -0700, Dave Hansen wrote:
> Changes from last version:
> * Define pr_fmt before any headers to keep from having
>   to undef it
> 
> Previous changes:
> * Changed logging functions to use cleaner helpers
> * created non-lock-taking __nasgpio_led_set_attr() and
>   a lock-taking version with no '__'.
> * added Kconfig dependency on DMI
> * Added some 'static's to functions
> * Added __devinit to init-time functions
> * Add missed pci_disable_device() on probe error and
>   device removal
> * Added dmi-basd hardware detection, and modparam
>   override for it
> * replaced DRIVER_NAME with KBUILD_MODNAME

Thanks for the updates, I've queued the updated version.

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

