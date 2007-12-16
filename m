Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXLPL6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXLPL6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763347AbXLPL6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:58:30 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37859 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761184AbXLPL63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:58:29 -0500
Message-ID: <476512F1.5010701@davidnewall.com>
Date: Sun, 16 Dec 2007 22:28:41 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
References: <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp>	<200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>	<47650A4C.4000708@davidnewall.com>	<200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>	<47650C88.6040105@davidnewall.com> <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
>>> I meant that "/dev must be mounted for read-write mode"
>>>       
>> Again, why?
>>     
>
> You won't be able to login to the system because /sbin/mingetty
> fails to "chown/chmod" /dev/tty* if /dev is mounted for read-only mode.
>   

Good point.  So, if only root can modify files in /dev, what's the 
problem you're fixing?  (I'm sure you tried to explain this in your 
original post, but your reasons weren't clear to me.)
