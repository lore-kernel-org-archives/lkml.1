Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYJQScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYJQScU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYJQScK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:32:10 -0400
Received: from mailout03.t-online.de ([194.25.134.81]:59898 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbYJQScJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:32:09 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 14:32:08 EDT
Message-ID: <48F8D5DA.4070209@t-online.de>
Date: Fri, 17 Oct 2008 20:13:46 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.1: install conflict about /lib/firmware
References: <48F78C5C.8080907@t-online.de> <48F7AB05.50103@msgid.tls.msk.ru>
In-Reply-To: <48F7AB05.50103@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: ZeAgY6ZAwha0vLDWNYXkV3VruDvq2yscjfjfOS+kEaFHJjfF0K+hmLzM2YBNqJvZGM
X-TOI-MSGID: 8a59ab9a-e159-47dc-aedc-16a6ef5944cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> 
> Since 2.6.27, firmware binaries are placed into /lib/firmware
> directory.  The reason is that firmware is not kernel-dependent.
> Or, rather, the firmware stored here is not kernel-dependent
> (when it is, it's stored in /lib/modules/$version/).
> 

It would be nice if this could be configured. I wouldn't like
to have 2 directories to look for firmware files.

Actually I did not want to build any firmware drivers, but setting
CONFIG_PREVENT_FIRMWARE_BUILD did not work.


Regards

Harri
