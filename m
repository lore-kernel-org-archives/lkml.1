Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbYERPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbYERPoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYERPoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 11:44:11 -0400
Received: from ns1.codewiz.org ([89.97.188.34]:57592 "EHLO trinity.develer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbYERPoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 11:44:10 -0400
Message-ID: <48304EC8.5040908@codewiz.org>
Date: Sun, 18 May 2008 17:44:08 +0200
From: Bernie Innocenti <bernie@codewiz.org>
Organization: Codewiz - http://www.codewiz.org/
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: lkml <linux-kernel@vger.kernel.org>, ext3-users@redhat.com,
       ext2-devel@lists.sourceforge.net, Stefano Fedrigo <aleph@develer.com>
Subject: Re: ext3_dx_add_entry: Directory index full!
References: <48304CE2.1090808@codewiz.org> <1211125179.21380.2.camel@pmac.infradead.org>
In-Reply-To: <1211125179.21380.2.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:

> On Sun, 2008-05-18 at 17:36 +0200, Bernie Innocenti wrote:
>>
>>   static inline unsigned dx_root_limit (struct inode *dir, unsigned
>> infosize)
>>   {
>>       unsigned entry_space = dir->i_sb->s_blocksize -
>> EXT3_DIR_REC_LEN(1) -
>>           EXT3_DIR_REC_LEN(2) - infosize;
>>       return 0? 20: entry_space / sizeof(struct dx_entry);
>>   }
>>
>> Am I reading the above code correctly?  Why does it always return
>> 20 no matter what?
> 
> It doesn't. "condition?A:B" will return A if the condition is _true_,
> which it isn't.

Oh... I feel stupid.

-- 
   \___/
  _| X |  Bernie Innocenti - http://www.codewiz.org/
  \|_O_|  "It's an education project, not a laptop project!"
