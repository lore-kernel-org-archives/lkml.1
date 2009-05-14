Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZENUEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZENUEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZENUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:04:09 -0400
Received: from n57.bullet.mail.sp1.yahoo.com ([98.136.44.49]:30524 "HELO
	n57.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751225AbZENUEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:04:08 -0400
X-Yahoo-Newman-Id: 16104.92964.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=W0oDSbwTCMAJ3IqQ1DWlMokXDP2SpNk5kMb9wmXNhbhxAwbMt7LB+yAirqgVY/KpJH8M3ZK9jig3eXA0CTUfycKQ52m5WLSwWlRskAHjd5cZDeMKqJcanubnxO6JJgeYuCIru3aP2/xT+spj/QOZBhEzXlAFDw+ZdQiR/9wQTqo=  ;
X-YMail-OSG: PmhnFPQVM1mAcjYTuh50TU2p.wEI6RtcHW_J7Z6Ddt4Lp65RjSMo4i8Iv8nJn_X60bj0QSoJqUdn1uRBsV0rEbvcUeZGBZn_zynQHcXq8zS8QG2hUealgJU.9lbTEZlLzp2DuF3Xi21RkF0JWl1bjwvysplkmwOI0v0VQVhwyFscg59lpAAGDDirH0WtE5Ob.ZfzcwTc82gMjGTRKXqTsCLVzTr0zPqW3xaiViqK3qfRT0SlBMlhbnpTfeksWK9wHWsP8DoMcHh5czuhRlXxaVKHE1bjenH_eU33Q6.FX3pqQLxSfrQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Subject: [patch 0/3] DaVinci ASoC updates
Date: Thu, 14 May 2009 12:35:35 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>,
       DaVinci <davinci-linux-open-source@linux.davincidsp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905141235.35600.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.30-rc5 merges included a bunch of DaVinci platform
updates, including EDMA support.  Which means that finally
the ASoC stuff can be made to build in mainline ... it was
probably sent to mainline before its time.  ;)

Following are three patches which resync mainline ASoC code
with what's in the DaVinci tree.  I'd like to suggest they
all merge before 2.6.30-final ... two are build fixes, and
the third is needed to make it work.

(I'm cc'ing all interested parties -- except alsa-devel,
which is members-only -- on this note, but will only cc
the DaVinci list on the three patches.)

