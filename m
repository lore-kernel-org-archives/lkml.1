Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZLANZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZLANZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZLANZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:25:38 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:60958 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZLANZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:25:37 -0500
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 08:25:36 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=DbAqCSMXNB0qUT10kUeveHKMGlvZO3DaMiaropzq2zL7vXGJvo2m6HSa1Yyi7ciIMa
         Hvt6c0iNuEKCn3tgUHYc6hKC3ctWIbsibsKPJUsgF4mBguF6Zp8AWbFdNpz0tAe+4Jxc
         vhutWcHsnaAxPpJhcGyaGgZ+sBEWW1pwd3LIQ=
Date: Tue, 1 Dec 2009 21:21:32 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Cc: "strongzgy" <strongzgy@gmail.com>, "xgr178" <xgr178@163.com>,
       "Liu Hui" <onlyflyer@gmail.com>, "viro" <viro@zeniv.linux.org.uk>,
       "akpm" <akpm@linux-foundation.org>, "jack" <jack@suse.cz>,
       "npiggin" <npiggin@suse.de>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200911252209432039291@gmail.com>,
 <20091125141505.GH9482@parisc-linux.org>,
 <a229bc400911251120y220066afjb10d391198c5807c@mail.gmail.com>,
 <20091125195256.GL9482@parisc-linux.org>,
 <b3657a100911302101t59a07518tddfd0a267d4ce64c@mail.gmail.com>,
 <20091201120337.GV9482@parisc-linux.org>
Subject: Re: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
Message-ID: <200912012115341872867@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nB1DPp16020943

Hi Matthew Wilcox:
	I got the code note as the following. if there is no performance problem, 
maybe the code note need update.


------
 *	BUGS:
 *	With a large number of inodes live on the file system this function
 *	currently becomes quite slow.


------------------		
Best Regards,		 
Liuweni
2009-12-01

-------------------------------------------------------------
·¢¼şÈË£ºMatthew Wilcox
·¢ËÍÈÕÆÚ£º2009-12-01 20:03:41
ÊÕ¼şÈË£ºliu weni
³­ËÍ£ºstrongzgy; xgr178; Liu Hui; viro; akpm; jack; npiggin; linux-fsdevel; linux-kernel
Ö÷Ìâ£ºRe: [PATCH 1/3]fs/inode: iunique() Optimize Performance

On Tue, Dec 01, 2009 at 01:01:57PM +0800, liu weni wrote:
> Thanks, I will try others way to improve the performance.

Is there a performance problem with iunique?  What benchmark are you
running to show this?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
