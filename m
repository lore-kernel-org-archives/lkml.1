Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbYEZLtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbYEZLtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYEZLtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:49:46 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:40063 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754313AbYEZLtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:49:46 -0400
Message-ID: <483AA3D2.3@davidnewall.com>
Date: Mon, 26 May 2008 21:19:38 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Shuduo Sang <sangshuduo@gmail.com>, devzero@web.de,
       bosko.radivojevic@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Inserting code from userspace to kernel space
References: <289344083@web.de> <ee101c360805242037y333b3e17n705ef9b1572125c9@mail.gmail.com> <4838E147.5000903@davidnewall.com> <Pine.LNX.4.64.0805261143450.18218@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0805261143450.18218@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> This is different, because the firmware that is loaded by 
> request_firmware() is not meant to be interpreted/executed by the kernel, 
> drivers usually just pass it over to the device.

Usually, but not obligatory.  It seems like it might be useful to
overload the mechanism for the specified requirement.  It's just an idea.
