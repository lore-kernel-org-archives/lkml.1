Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZDEESY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZDEESY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 00:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZDEESP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 00:18:15 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41252 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZDEESO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 00:18:14 -0400
Subject: Re: CONFIG_FW_LOADER
From: Marcel Holtmann <marcel@holtmann.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1238868348.6489.8.camel@localhost.localdomain>
References: <1238868348.6489.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 06:18:09 +0200
Message-Id: <1238905089.19390.7.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

> Currently the help for this states: 
> 
> 
> CONFIG_FW_LOADER:
> This option is provided for the case where no in-kernel-tree modules
> require userspace firmware loading support, but a module built outside
> the kernel tree does.
> 
> 
> Is it just me or is this somewhat misleading? Don't all modules that
> load firmware from userspace require this?

all drivers that do use 'select FW_LOADER' and so they trigger building
this module anyway. The config option is purely if you have a driver
that is built outside the tree and wanna use request_firmware().

Regards

Marcel


