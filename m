Return-Path: <linux-kernel-owner+w=401wt.eu-S939158AbXGSPYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939158AbXGSPYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbXGSPY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:24:26 -0400
Received: from gw.goop.org ([64.81.55.164]:39699 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905AbXGSPYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:24:25 -0400
Message-ID: <469F81F3.2030102@goop.org>
Date: Thu, 19 Jul 2007 08:23:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: New 'Section mismatch:' warning in current git
References: <469F4BBF.6080904@googlemail.com>
In-Reply-To: <469F4BBF.6080904@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hello,
>
> on current git head I see this new warning caused by commit
> c70df74376c1e29a04e07e23dd3f4c384d6166dd
>
> ...
>
>   MODPOST vmlinux
> WARNING: arch/i386/kernel/built-in.o(.text+0xc290): Section mismatch:
> reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and
> 'initialize_secondary')
> WARNING: arch/i386/kernel/built-in.o(.text+0xc29e): Section mismatch:
> reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and
> 'initialize_secondary')

Thanks.  I posted wli's fix for this yesterday.

    J
