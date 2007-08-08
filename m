Return-Path: <linux-kernel-owner+w=401wt.eu-S937473AbXHHSOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937473AbXHHSOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764281AbXHHSOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:14:14 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36580 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188AbXHHSON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:14:13 -0400
Date: Wed, 8 Aug 2007 20:15:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Consolidate show_regs and show_registers for i386
Message-ID: <20070808181530.GA18620@uranus.ravnborg.org>
References: <46B9D047.9090000@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B9D047.9090000@openvz.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 06:16:39PM +0400, Pavel Emelyanov wrote:
> Both functions printk the same information, except for CRx and
> debug registers in the show_registers() one and a bit different
> manner. So move the common code into one place. This is already
> done for x86_64, so I think it's worth having the same on i386.

Hi Pavel.

As a general note that also applies to your mails...
Please do not include linux-arch for for issues that does only
concern or are only relevant for a single architecture.

	Sam
