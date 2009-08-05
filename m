Return-Path: <linux-kernel-owner+w=401wt.eu-S933623AbZHEHLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbZHEHLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933520AbZHEHLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:11:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:60628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933391AbZHEHLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:11:51 -0400
Message-ID: <4A793099.1040704@kernel.org>
Date: Wed, 05 Aug 2009 16:11:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
References: <4A79283E.7030202@kernel.org> <s5hzlaed9me.wl%tiwai@suse.de>
In-Reply-To: <s5hzlaed9me.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 07:11:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Wed, 05 Aug 2009 15:35:42 +0900,
> Tejun Heo wrote:
>> [un]register_chrdev() assume minor range 0-255.  This patch adds __
>> prefixed versions which take @minorbase and @count explicitly.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> ---
>> Hello,
>>
>> These two patches make sound_core grabbing OSS device number optional.
>> If there's no objection, I think it would be easiest to push this
>> through Takashi's tree.
> 
> I'm fine to take this.
> 
> But, I think EXPORT_SYMBOL(__register_chrdev) and
> EXPORT_SYMBOL(__unregister_chrdev) are missing in this patch.

The only current users would be sound_core.c which is always compiled
built-in.  Adrian would be mighty unhappy about adding EXPORT_SYMBOL()
there.

Thanks.

-- 
tejun
