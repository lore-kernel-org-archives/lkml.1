Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbXHCMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbXHCMoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXHCMoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:44:08 -0400
Received: from aun.it.uu.se ([130.238.12.36]:56984 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbXHCMoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:44:07 -0400
Date: Fri, 3 Aug 2007 14:44:00 +0200 (MEST)
Message-Id: <200708031244.l73Ci0GU020922@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: Gregor.Fajdiga@guest.arnes.si, linux-kernel@vger.kernel.org
Subject: Re: CD/DVD-ROM: ide vs. libata
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 13:12:10 +0200, Grega Fajdiga wrote:
> Hello, LKML,
> 
> I'm wondering if the old ide-cd from the ide subsystem is still
> necessary to get a CD/DVD-ROM working or is there a libata driver
>    available already,
> 
> Please CC me since I'm not subscribed.

If you use libata then you don't need anything from CONFIG_IDE,
including ide-cd and ide-scsi.
