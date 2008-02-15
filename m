Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYBORZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYBORZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYBORYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:24:55 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:60044 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYBORYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:24:54 -0500
Message-ID: <47B5CAE4.1000905@grupopie.com>
Date: Fri, 15 Feb 2008 17:24:52 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
References: <20080214162104.GA5347@ics.muni.cz>
In-Reply-To: <20080214162104.GA5347@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> [...]
> If I'm scping file (about 500MB) from the network (which is faster than the
> local disk), any process is totally unable to read anything from the local disk
> till the scp finishes. It is not caused by low free memory, while scping
> I have 500MB of free memory (not cached or buffered).

If you want to take advantage of all that memory to buffer disk writes, 
so that the reads can proceed better, you might want to tweak your 
/proc/sys/vm/dirty_ratio amd /proc/sys/vm/dirty_background_ratio to more 
appropriate values. (maybe also dirty_writeback_centisecs and 
dirty_expire_centisecs)

You can read all about those tunables in Documentation/filesystems/proc.txt.

Just my 2 cents,

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
