Return-Path: <linux-kernel-owner+w=401wt.eu-S1032508AbXEHWfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032508AbXEHWfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032495AbXEHWf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:35:28 -0400
Received: from main.gmane.org ([80.91.229.2]:42828 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968461AbXEHWfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:35:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: michael.mauch@gmx.de (Michael Mauch)
Subject: Re: [PATCH] time locale in gen_initramfs_list.sh
Date: Wed, 09 May 2007 00:34:36 +0200
Organization: no
Message-ID: <sga7h4xlpf.ln2@elmicha.333200002251-0001.dialin.t-online.de>
References: <200705080755.31157.florian.fainelli@int-evry.fr> <464059BE.6010304@zytor.com> <200705081646.47568.florian.fainelli@int-evry.fr>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pd9e84a75.dip.t-dialin.net
User-Agent: tin/1.8.3-20070201 ("Scotasay") (UNIX) (Linux/2.6.20-gentoo-r8 (i686))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Fainelli wrote:

> This is true. According to GNU fileutils changelog, the nearest Changelog 
> message regarding this option is :
> 
> 2004-11-19  Alfred M. Szmidt  <ams@gnu.org>
> 
>        * src/ls.c (usage): Clarified description of --no-group (-G),
>        --human-readable (-h), --inode (-i), --size (-s), --time,
>        and --time-style.

It's also possible to overwrite that TIME_STYLE variable (which is
responsible for the format change), like so

  LC_ALL=C TIME_STYLE=locale ls -l ...

Regards...
		Michael

