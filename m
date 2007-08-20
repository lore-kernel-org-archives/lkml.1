Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbXHTNxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbXHTNxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbXHTNxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:53:06 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:26262 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXHTNxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:53:02 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 2/4] Introduce a new fields "gtime" and "cgtime" in task_struct and signal_struct
Date: Mon, 20 Aug 2007 15:52:57 +0200
User-Agent: KMail/1.9.7
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
References: <46C99392.3050205@bull.net>
In-Reply-To: <46C99392.3050205@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708201552.57617.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. August 2007 schrieb Laurent Vivier:
> Index: kvm/fs/proc/array.c
> ===================================================================
> --- kvm.orig/fs/proc/array.c    2007-08-20 11:11:30.000000000 +0200
> +++ kvm/fs/proc/array.c 2007-08-20 13:04:03.000000000 +0200

Just a heads up, this patch collides with this fix in mm:
http://marc.info/?l=linux-mm-commits&m=118737949222362&w=2

If Ingo accepts this fix, your patch should be adopted in array.c to use 
cputime_t for gtime as well. Lets see what Ingo thinks.


Christian
