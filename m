Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbYBCSKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbYBCSKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYBCSKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:10:32 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:56696 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303AbYBCSKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:10:32 -0500
From: Frank Seidel <frank@f-seidel.de>
To: Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] Remove unneeded code in sys_getpriority
Date: Sun, 3 Feb 2008 19:10:28 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080203030429.GB7459@ubuntu> <200802031054.45604.frank@f-seidel.de> <20080203175854.GB3124@ubuntu> (sfid-20080203_190515_304540_24F4CBC029C088AF)
In-Reply-To: <20080203175854.GB3124@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031910.28621.frank@f-seidel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 February 2008 18:58, Rabin Vincent wrote:
> Do you mean the PRIO_* cases in the switch?  They're still independent
> of position after the patch because they don't fall through.

Yes, sure, this is fully correct now. Just if somehting whatsoever
is put ahead touching retval one need to take care of this here.
But as i don't have enough experience to know if this likely at all i'm
fully fine with it. Just wanted to note one should think about if
its worth the change.

Thanks,
Frank
