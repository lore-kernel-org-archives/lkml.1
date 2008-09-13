Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYIMHX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYIMHX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 03:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYIMHXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 03:23:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYIMHXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 03:23:46 -0400
Date: 13 Sep 2008 09:20:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: maximlevitsky@gmail.com
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jwilson@redhat.com
Cc: kraxel@redhat.com
Cc: linux-kernel@vger.kernel.org
Cc: superm1@ubuntu.com
Message-ID: <AlnE2jFojFB@christoph>
In-Reply-To: <48C98D64.7050909@gmail.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19mtGVAKZ/7NfGqLF5Gx4UKX4syxgbfb0fOuHA
 cscq5J+flJSu403BdjOTQ1ddrpja/kfsEuznCiAWU+MRgTyt25
 zwVTuVB8Nli+eViDLg8ExwY8oBGRPJO3oU+XY8EIW8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxim,

on 12 Sep 08 at 00:28, Maxim Levitsky wrote:
[...]
> What do you, lirc developers think about making lircd a daemon that injects
> input events via uinput?

I have already agreed to implement this in lircd.
The reason why I didn't until now is that there never was any reguest for
such a feature from real users of LIRC. This is often suggested by people
from an architectural viewpoint, because it's nice to have a unified
interface through the input layer. But if you start using LIRC you usually
realise quite fast that simple key events are not enough to build a remote
controlled home entertainment system for example.
But if enough people want this feature, it will be in the next release.

Christoph
