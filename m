Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbXJOPpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbXJOPpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbXJOPo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:44:57 -0400
Received: from lazybastard.de ([212.112.238.170]:53592 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbXJOPo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:44:56 -0400
Date: Mon, 15 Oct 2007 17:40:27 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015154027.GA21250@lazybastard.org>
References: <20071014190128.6e3cdb44@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071014190128.6e3cdb44@bree.surriel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 October 2007 19:01:28 -0400, Rik van Riel wrote:
> 
> If you have ideas on what projects would be useful, please add them
> to this page (or email me):

Maybe this:

Allow removal of select from Kconfig files

Difficulty: 4

Many config options depend on other options is unrelated submenus.  As a
result, people have complained about not being able to select the
desired option because they finding all dependencies is too complicated.
Select solves this problem and creates a near-identical new one.  Now it
is just as hard to turn some options _off_ as it was before to turn
others _on_.

The solution would be to have smarter tools that give the user
information roughly like this:
  [ ] CONFIG_FOO
      If you enable this option, you will also enable CONFIG_BAR.
Or :
  [x] CONFIG_BAR
      If you disable this option you will also disable CONFIG_FOO
      and CONFIG_FOO2.

Difficulty is somewhat increased by the number of tools that require
such functionality.  Support for xconfig and menuconfig appears to have
priority as those users have a harder time grepping the kernel.

Jörn

-- 
There is no worse hell than that provided by the regrets
for wasted opportunities.
-- Andre-Louis Moreau in Scarabouche
