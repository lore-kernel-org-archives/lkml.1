Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbYFUHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbYFUHAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYFUHAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 03:00:05 -0400
Received: from mail.aknet.ru ([78.158.192.26]:49480 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYFUHAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 03:00:04 -0400
Message-ID: <485CA721.2080806@aknet.ru>
Date: Sat, 21 Jun 2008 11:00:49 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: ALSA devel <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc6 snd-pcsp: "Timer resolution is not sufficient"
References: <485AB878.5080101@keyaccess.nl> <485B2A92.4000801@aknet.ru> <485C55E8.3090703@keyaccess.nl>
In-Reply-To: <485C55E8.3090703@keyaccess.nl>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Rene Herman wrote:
> In this case the problem was the ACPI PM-Timer (CONFIG_X86_PM_TIMER) got
> disabled. Re-enabling it, snd-pcsp is working fine again.
Note that this option is available
only if you enable CONFIG_EMBEDDED.
Most people will just never see it.
