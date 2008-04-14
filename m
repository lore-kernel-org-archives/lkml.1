Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYDNLtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYDNLtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYDNLtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:49:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYDNLtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:49:13 -0400
Message-ID: <480343F2.3040401@zytor.com>
Date: Mon, 14 Apr 2008 04:45:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alexia Death <alexiadeath@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
References: <200804132326.07713.alexiadeath@gmail.com> <200804140245.33171.arnd@arndb.de> <200804140749.57049.alexiadeath@gmail.com> <200804140848.39226.arnd@arndb.de>
In-Reply-To: <200804140848.39226.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> On the contrary, the USB card readers go through a lot of effort to
> make the card look like a SCSI device, and many of these implementations
> are buggy in some way. SD cards are defined to have 512 byte sectors, while
> USB mass storage can theoretically have a different sector size. Of course
> any other size than 512 bytes is likely to break some code, which you have
> experienced.
> 

Actually, I believe 2 GB (non-SDHC) *only* have 1024 byte sectors.

	-hpa
