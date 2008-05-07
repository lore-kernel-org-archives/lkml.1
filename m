Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYEGC5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYEGC5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYEGC5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:57:24 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:46666 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbYEGC5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:57:23 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200805070257.m472v9vu004722@clem.clem-digital.net>
Subject: Re: Lost Sound from 2.6.24 to 2.6.25 -- CS4236 ISA
To: rene.herman@keyaccess.nl (Rene Herman)
Date: Tue, 6 May 2008 22:57:09 -0400 (EDT)
Cc: clem@clem.clem-digital.net (Pete Clements), tiwai@suse.de (Takashi Iwai),
       linux-kernel@vger.kernel.org (linux-kernel),
       bjorn.helgaas@hp.com (Bjorn Helgaas)
In-Reply-To: <48207E90.9000202@keyaccess.nl>
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rene Herman
  > 
  > There have been quite a few post .25 changes to PnP. Is there a difference 
  > between .24 and .25 or between .24/.25 on the one hand and .26-rc1-git4 on 
  > the other?
  > 
  > Also, does using PNPACPI instead of PNPBIOS change anything?
  > 
  > Rene.
  > --
  > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
  > the body of a message to majordomo@vger.kernel.org
  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
  > Please read the FAQ at  http://www.tux.org/lkml/
  > 
Had a cold reboot today, now 2.6.25 is working just like 2.6.24. Have rebooted
in and out of 25 multi time and all is fine. Nothing changed to my knowledge so
I can't explain, must have had something screwed up. 

Problem does exist post 2.6.25, except just silence. Did manage to get the
cyclic noise back after removing pnp, failing a module load, and adding pnp
back with warm reboots. 

System will not configure PNPACPI.

-- 
Pete Clements 
