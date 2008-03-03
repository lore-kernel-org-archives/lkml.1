Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYCCQmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYCCQmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYCCQmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:42:44 -0500
Received: from er-systems.de ([85.25.136.202]:52263 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbYCCQmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:42:43 -0500
Date: Mon, 3 Mar 2008 17:42:41 +0100 (CET)
From: Thomas Voegtle <tv@lio96.de>
To: linux-kernel@vger.kernel.org
cc: tilman.baumann@collax.com, Andreas Hofmeister <andi@collax.com>
Subject: Re: permissions on /proc/tty/driver/
In-Reply-To: <Pine.LNX.4.64.0802291912310.24941@er-systems.de>
Message-ID: <Pine.LNX.4.64.0803031740460.15875@er-systems.de>
References: <Pine.LNX.4.64.0802291912310.24941@er-systems.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-1990418316-1204562561=:15875"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-1990418316-1204562561=:15875
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 29 Feb 2008, Thomas Voegtle wrote:

> we noticed that only root can enter /proc/tty/driver/, which appears to be 
> wrong, because the files therein are actually world readable...

I found out why this was done:

http://www.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.29

Chris Wright:
  o /proc/tty/driver/serial reveals the exact number of characters used
in serial links (CAN-2003-0461)


So, please ignore this patch I sent.

      Thomas

-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-1990418316-1204562561=:15875--
