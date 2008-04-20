Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbYDTIcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbYDTIcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYDTIbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:31:31 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:36731 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012AbYDTIb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:31:29 -0400
Date: Sun, 20 Apr 2008 10:30:19 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Alex Dubov <oakad@yahoo.com>
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Pavel Pisa <ppisa@pikron.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Anderson Briglia <briglia.anderson@gmail.com>,
       "Syed Mohammed, Khasim" <x0khasim@ti.com>,
       Russell King <rmk@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] MMC multiwrite capability removal
Message-ID: <20080420103019.7c31cb9f@mjolnir.drzeus.cx>
In-Reply-To: <896748.37554.qm@web36708.mail.mud.yahoo.com>
References: <20080419095136.15a50cc9@mjolnir.drzeus.cx>
	<896748.37554.qm@web36708.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 19:34:12 -0700 (PDT)
Alex Dubov <oakad@yahoo.com> wrote:

> 
> tifm_sd relies on controller to report the number of successfully transferred
> blocks. Of course, I cannot be sure to what extent the controller is
> trustworthy. It worked fine until now, though.
> 

Sounds like a perfect example of when we have to report 0 upon
failures. I suspect most controllers will be like this as all the specs
I've glanced at lack the detail needed to implement a proper sector
count.

The problems caused by reporting incorrect values here are extremely
rare and difficult to provoke, so normal testing is not likely to
uncover it.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
