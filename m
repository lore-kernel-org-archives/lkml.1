Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYGDGpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYGDGpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYGDGpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:45:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:31792 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYGDGpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oi9PHL0rKgJbPMyf+b+wQqF7RgadcLRUQFaK9lPTlDWW3sEhHSfJazHuwkX2XAdMSF
         rPl2tZFAepnl+ZIfieS4cHHzFy7byfShTJ5EMAolYpGpxONoV193jRzBLcinoWSWhUrj
         Jg51rXBoNapWhgPkofy478FGQew4hOyDFV/Nc=
Message-ID: <486DC6D2.6020303@gmail.com>
Date: Fri, 04 Jul 2008 15:44:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 07/15] sysfs: sysfs_chmod_file handle multiple superblocks
References: <20080618170729.808539948@theryb.frec.bull.fr>	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>	<486C4515.1070007@gmail.com> <m1hcb7o8lv.fsf@frodo.ebiederm.org>	<486CB051.5000507@fr.ibm.com> <m14p77m9uy.fsf@frodo.ebiederm.org>	<486CF71F.5090405@gmail.com> <m1y74iiidz.fsf_-_@frodo.ebiederm.org>	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>	<m1prpuihjb.fsf_-_@frodo.ebiederm.org>	<m1lk0iihhp.fsf_-_@frodo.ebiederm.org>	<m1hcb6ihfz.fsf_-_@frodo.ebiederm.org>	<m1d4luihea.fsf_-_@frodo.ebiederm.org>	<m18wwiihbn.fsf_-_@frodo.ebiederm.org> <m14p76ih9a.fsf_-_@frodo.ebiederm.org>
In-Reply-To: <m14p76ih9a.fsf_-_@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Teach sysfs_chmod_file how to handle multiple sysfs superblocks.
> Since we only have one inode per sd the only thing we have to deal
> with is multiple dentries for sending fs notifications.  This might
> dup the inode notifications oh well.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Great, Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
