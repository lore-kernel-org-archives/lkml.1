Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZEITAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZEITAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 15:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZEITAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 15:00:31 -0400
Received: from nn7.de ([85.214.94.156]:58844 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZEITAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 15:00:30 -0400
Subject: Re: regression 2.6.30-rc4+git: oops in rfcomm_tty_open
 klist_add_tail
From: Soeren Sonnenburg <sonne@debian.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1241853227.4903.85.camel@localhost.localdomain>
References: <1241852186.14865.63.camel@localhost>
	 <1241853227.4903.85.camel@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 09 May 2009 21:00:27 +0200
Message-Id: <1241895627.17060.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-09 at 00:13 -0700, Marcel Holtmann wrote:
> Hi Soeren,
> 
> > I am seeing the oops below as soon as I try to bring up my internet
> > connection over rfcomm via a bluetooth device. I think that things were
> > working ok with 2.6.30-rc3 still but now I see this oops even after a
> > clean reboot, reproducibly ...
> 
> please test with 2.6.30-rc5 since this one should be fixed. There is one
> additional patch waiting in net-2.6 that fixes a memory allocation in a
> context that can't sleep.

Yes indeed, things work again with -rc5, thanks for the quick reply!

Soeren
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
