Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYERSc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYERSc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYERScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:32:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35412 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYERScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:32:20 -0400
Date: Sun, 18 May 2008 20:32:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: bernie@codewiz.org
cc: lkml <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       ext3-users@redhat.com, ext2-devel@lists.sourceforge.net,
       Stefano Fedrigo <aleph@develer.com>
Subject: Re: ext3_dx_add_entry: Directory index full!
In-Reply-To: <48304D92.1080306@develer.com>
Message-ID: <alpine.LNX.1.10.0805182032030.15590@fbirervta.pbzchgretzou.qr>
References: <48304CE2.1090808@codewiz.org> <48304D92.1080306@develer.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-05-18 17:38, Bernie Innocenti wrote:
> Bernie Innocenti wrote:
>> On 2.6.24.4-64.fc8, I createed and mounted a filesystem like this:
>> 
>>   mke2fs -m0 -b 1024 -R stride=64 -I 128 -i 2048 -j  -L mail -O
>>   dir_index,sparse_super -v /dev/sdc1
>
> I cannot reproduce it any more if I reformat omitting "-b 1024".
> Maybe it would reappear with 200K * 4 = 800K files?

In that case you might want to switch the filesystems.
