Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbYERPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbYERPpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYERPpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 11:45:41 -0400
Received: from ns1.codewiz.org ([89.97.188.34]:57691 "EHLO trinity.develer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYERPpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 11:45:41 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 May 2008 11:45:40 EDT
Message-ID: <48304D92.1080306@develer.com>
Date: Sun, 18 May 2008 17:38:58 +0200
From: Bernie Innocenti <bernie@develer.com>
Reply-To: bernie@codewiz.org
Organization: Develer s.r.l. - http://www.develer.com/
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>, ext3-users@redhat.com,
       ext2-devel@lists.sourceforge.net, Stefano Fedrigo <aleph@develer.com>
Subject: Re: ext3_dx_add_entry: Directory index full!
References: <48304CE2.1090808@codewiz.org>
In-Reply-To: <48304CE2.1090808@codewiz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernie Innocenti wrote:
> On 2.6.24.4-64.fc8, I createed and mounted a filesystem like this:
> 
>   mke2fs -m0 -b 1024 -R stride=64 -I 128 -i 2048 -j  -L mail -O dir_index,sparse_super -v /dev/sdc1

I cannot reproduce it any more if I reformat omitting "-b 1024".
Maybe it would reappear with 200K * 4 = 800K files?

-- 
   \___/
  _| X |  Bernie Innocenti - http://www.codewiz.org/
  \|_O_|  "It's an education project, not a laptop project!"
