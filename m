Return-Path: <linux-kernel-owner+w=401wt.eu-S1764474AbXGFSAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764474AbXGFSAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761029AbXGFSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:00:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759801AbXGFSAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:00:34 -0400
Message-ID: <468E833C.6030300@redhat.com>
Date: Fri, 06 Jul 2007 14:00:28 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Clemens Koller <clemens.koller@anagramm.de>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce panic_gently
References: <Pine.LNX.4.58.0707060034330.18989@be1.lrz> <468DF5D9.4040803@anagramm.de>
In-Reply-To: <468DF5D9.4040803@anagramm.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2007 03:57 AM, Clemens Koller wrote:
> Bodo Eggert schrieb:
>> If the boot process failes to find init or the root fs, the cause has
>> usually scrolled off the screen, and because of the panic, it can't be
>> reached anymore.
>>
>> This patch introduces panic_gently, which will allow to use the
>> scrollback buffer and to reboot, but it can't be called from unsafe
>> context.
> 
> In the case where you introduced panic_gently() there is IMHO no reason
> to panic() at all. There is no bug which got hit, the machine just needs
> user intervention because of wrong boot parameters (in most cases).
> 
> What about asking the user for the correct root= or init= parameters
> and just retry/continue the boot process?
> 
> The 180seconds reboot timeout also doesn't make sense here. The problem
> won't go away after a reboot without user interaction.

What about GRUB fallbacks? The fallback image/kernel will start
automatically on reboot if you use that feature.

