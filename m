Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbZJPFTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbZJPFTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 01:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZJPFTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 01:19:49 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:49490 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZJPFTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 01:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=gFOUIi3TzjycyAfh5degw4Cey3xhQA6UEMAUizKdw4IS7YQCkv7nf+lUvVadvIa2MV
         E2AOjujdvFX4YRGeqhJ8OwDVniRJsoCNuJi/mZAZCuk88T47y+cxDKNJYshNN/pzfG0K
         WMQk4HihZ7T5B5C/vcKLbLWveiiEjMVQ0Zn3s=
Date: Fri, 16 Oct 2009 14:17:19 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Chungki woo <chungki.woo@gmail.com>
Subject: BUG? linux-mips flush_dcache_page
Message-Id: <20091016141719.de606482.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

			
Hi, Ralf. 

I suffered form data consistency problem. 

Many code of kernel fs usually allocate high page and flush.
But flush_dcache_page of mips checks PageHighMem to avoid flush
so that data consistency is broken, I think. 

I found it's by you and Atsushi-san on 585fa724. 
Why do we need the check?
Could you elaborte please? 

-- 
Kind regards,
Minchan Kim
