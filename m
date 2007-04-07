Return-Path: <linux-kernel-owner+w=401wt.eu-S965824AbXDGMwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965824AbXDGMwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 08:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965829AbXDGMwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 08:52:05 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:36660 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965824AbXDGMwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 08:52:04 -0400
X-ME-UUID: 20070407125141708.AD09F1C00081@mwinf2123.orange.fr
Message-ID: <461793E4.5040706@free.fr>
Date: Sat, 07 Apr 2007 14:51:48 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Ignatich <ignatich@gmail.com>
Cc: reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       Edward Shishkin <edward@namesys.com>
Subject: Re: REISER4: fix for reiser4_write_extent
References: <46157B5B.5000602@gmail.com>
In-Reply-To: <46157B5B.5000602@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06.04.2007 00:42, Ignatich a écrit :
> While trying to find the cause of problems with reiser4 in recent 
> kernels I came across this.
> 
> Incomplete write handling seem to be missing from reiser4_write_extent() 
> thanks to reiser4-temp-fix.patch. Strangely, there is a patch by Edward 
> Shishkin that should address that issue, but it is missing from -mm 
> tree. Please check.
> 
>    Max
> 

This patch was added to -mm tree the 14 Dec 2006 (see 
http://www.mail-archive.com/mm-commits@vger.kernel.org/msg05338.html).

It was then dropped from -mm tree the 05 Mar 2007 (see 
http://www.mail-archive.com/mm-commits@vger.kernel.org/msg10818.html), 
with this comment:
	"This patch was dropped because it is obsolete"

No idea why it was obsolete. Does somebody know ?

~~
laurent

