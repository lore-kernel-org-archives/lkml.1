Return-Path: <linux-kernel-owner+w=401wt.eu-S1751214AbXCDLrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbXCDLrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 06:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXCDLrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 06:47:51 -0500
Received: from mail01.syd.optusnet.com.au ([211.29.132.182]:36679 "EHLO
	mail01.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbXCDLru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 06:47:50 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu  scheduler
Date: Sun, 4 Mar 2007 22:47:43 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>
References: <200703041800.53360.kernel@kolivas.org> <200703040608.53336.gene.heskett@gmail.com>
In-Reply-To: <200703040608.53336.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703042247.44196.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 22:08, Gene Heskett wrote:
> On Sunday 04 March 2007, Con Kolivas wrote:
> >This message is to announce the first general public release of the
> > "Rotating Staircase DeadLine" cpu scheduler.
>
> I assume to test this, we select the deadline scheduler?

No, only the "deadline" in the name is shared. This is a cpu process scheduler 
whereas the deadline scheduler you're thinking of is an I/O scheduler. To 
test this you just patch it in and it replaces the current mainline cpu 
scheduler (the same way the staircase cpu scheduler in -ck replaces it).

-- 
-ck
