Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbXGJWyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbXGJWyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 18:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXGJWyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 18:54:44 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34493 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbXGJWyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 18:54:44 -0400
Date: Tue, 10 Jul 2007 15:54:06 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] lost keyboard and lost terminal under kde3.5.5(debian
	version) with 2.6.22
Message-ID: <20070710225406.GB3845@kroah.com>
References: <6101e8c40707101534s23fb360fmfd658d1573aaf809@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40707101534s23fb360fmfd658d1573aaf809@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 12:34:32AM +0200, Oliver Pinter wrote:
>  Hi all!
> 
>  After 5hour running over the 2.6.22 i lost the keyborad under kde,
>  then I restarted the gdm, this can first SysRQ-W and switch to
>  terminal, thats ok, but 1 hour later again lost the "X" and again
>  probe the SysRQ+W, I get back the keyboard but the console crashed (as
>  if framebuffer error) after use he ctrl+alt+f1, however I use not
>  framebuffer. im syslog I see nothing, only one mtrr warning but I see
>  yet from 2.6.22-rc2or3.

So, 2.6.22-rc2 works just fine for you?

Can you use 'git bisect' to try to track down the problem?

thanks,

greg k-h
