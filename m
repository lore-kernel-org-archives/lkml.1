Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbYEFPjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbYEFPjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760196AbYEFPiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:38:51 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:33938 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761021AbYEFPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:38:50 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200805061538.m46FcgZ3002921@clem.clem-digital.net>
Subject: Re: Lost Sound from 2.6.24 to 2.6.25 -- CS4236 ISA
To: tiwai@suse.de (Takashi Iwai)
Date: Tue, 6 May 2008 11:38:42 -0400 (EDT)
Cc: clem@clem.clem-digital.net (Pete Clements),
       linux-kernel@vger.kernel.org (linux-kernel),
       rene.herman@keyaccess.nl (Rene Herman)
In-Reply-To: <s5hfxsvd31h.wl%tiwai@suse.de>
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Takashi Iwai
  > At Mon, 5 May 2008 10:06:51 -0400 (EDT),
  > Pete Clements wrote:
  > > 
  > > Looks like sound card stops functioning between
  > > 2.6.24 and 2.6.25.
  > 
  > Could you elaborate what do you mean exactly "stop"?  Fail to load or
  > initialize the driver, or silent output, DMA error...?
  > 
  > >  Sorry but don't know at what
  > > point.  Card is an isa CS4236. Glad to provide
  > > any other info/testing.
  > 
  > Any relevant kernel messages are welcome.  Also, if you passed any
  > (module) options for the sound driver, show it, too.
  > 
  > The biggest change in ISA sound driver codes between 2.6.24 and 2.6.25
  > is that we dropped the PnP resource re-configuration via module
  > options of sound drivers.  They have to be adjusted via sysfs now 
  > (if really needed).
  > 
  > Otherwise, if it really worked on 2.6.24, we have a good chance to
  > identify the affecting changeset via bisect.  There are only a few
  > changes for sound/isa.
  > 
  > 
  > thanks,
  > 
  > Takashi
  > --
All I get is a cyclic noise burst (about 500ms frequency). 
No options to module load, prior to 25 manually loaded modules
with 'modprobe snd-cs4236',  with 25+ modules auto load at boot.

By removing "CONFIG_PNPBIOS" get total silence. So would assume the
PNP change the source.

Currently running 26-rc1-git4.

- 
Pete Clements 
