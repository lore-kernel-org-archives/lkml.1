Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZETEgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZETEgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 00:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZETEgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 00:36:13 -0400
Received: from 1wt.eu ([62.212.114.60]:1482 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZETEgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 00:36:13 -0400
Date: Wed, 20 May 2009 06:36:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrea <andrea256it@yahoo.it>,
       linux-kernel@vger.kernel.org
Subject: Re: super root shell/mode/api
Message-ID: <20090520043603.GA9725@1wt.eu>
References: <861928.62033.qm@web23602.mail.ird.yahoo.com> <20090518103545.6603b08e@lxorguk.ukuu.org.uk> <20090518161231.GC20244@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518161231.GC20244@khazad-dum.debian.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 01:12:31PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 18 May 2009, Alan Cox wrote:
> > Your distribution failed to configure your system sensibly in that case.
> > Linux has supported a strict overcommit mode for some years, and in that
> > mode a process isn't permitted to drive the system so far out of memory
> > it locks up or hangs.
> 
> Err... strict overcommit is vm.overcommit_memory=2, right?  That means no
> overcommit at all (as far as the documentation goes, anyway).

exactly

> Which distros enable that by default?

I don't know if mainline distros do this, but some distros dedicated to
embedded systems have been using that for ages, almost since Alan published
his first overcommit patch a long time ago. It's the only way to reach
very long uptimes on servers, as it also protects you against your own
mistakes (eg: stupid actions such as "vi access.log" when the file is
larger than memory).

Willy

