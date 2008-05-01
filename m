Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbYEAOhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbYEAOhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYEAOh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:37:26 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:46964 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYEAOh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:37:26 -0400
Message-ID: <4819D5A1.6080204@isomerica.net>
Date: Thu, 01 May 2008 10:37:21 -0400
From: =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, krh@redhat.com,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-git16 -- BUG: unable to handle kernel NULL pointer dereference
 at 00000000 -- IP: [<c02dd5d5>] fw_show_drv_device_ids+0xd9/0xee
References: <a44ae5cd0804301729q77530ecerdbb65b4ed40eeba@mail.gmail.com>	 <tkrat.39b6a8e0dced1929@s5r6.in-berlin.de> <a44ae5cd0805010608n6c441082udd00c315e786de40@mail.gmail.com> <4819C941.6030209@s5r6.in-berlin.de>
In-Reply-To: <4819C941.6030209@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> I could look into keeping those messages down to only a single one per 
> attempt to fetch the so-called configuration ROM of an added node.

Seems like this is ideal.

> (The ROM CRC error warning has been added in 2.6.22.  Before Linux 
> 2.6.22, the ROM CRC errors were silently accepted.  The new alternative 
> firewire drivers also do not warn about ROM CRC errors... yet...)

I like to be warned about things, even if there isn't anything I can 
really do about it (fix my IEEE 1394 ROM CRC? :) But there doesn't seem 
to be any point to repeating the message.

Do the repeats come because it prints each time the config ROM is accessed?

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noé
                     |  http://isomerica.net/~dpn/
