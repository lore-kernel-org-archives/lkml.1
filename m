Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYGVOSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYGVOSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYGVOSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:18:25 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:62198 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYGVOSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:18:25 -0400
Date: Tue, 22 Jul 2008 14:18:23 +0000
From: Sean Young <sean@mess.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Led driver for technologic systems 5500
Message-ID: <20080722141823.GA81435@atlantis.8hz.com>
References: <20080721211403.GB72268@atlantis.8hz.com> <1216715492.5421.1.camel@dax.rpnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216715492.5421.1.camel@dax.rpnet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 09:31:32AM +0100, Richard Purdie wrote:
> On Mon, 2008-07-21 at 21:14 +0000, Sean Young wrote:
> > Here is a patch for the led on the Technologic Systems 5500 board. The
> > first patch had a bug in an error path. Detection is still a bit flimsy; Is 
> > there anything that can be done about that?
> 
> I'm not really familiar with how x86 does the machine detection but I
> agree the detection looks a bit flimsy. Can anyone advise on how this
> hardware could be better detected?

I think that's why DMI was invented, AFAIK. I have no idea whether how many
X86 devices exist on these I/O ports (0x77/0x74). The only other thing I can 
think of is that this is an AMD Elan so the Kconfig could depend on ELAN 
and not X86.


Sean
