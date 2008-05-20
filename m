Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbYETCOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbYETCOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYETCOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:14:22 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:40368 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbYETCOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IwLuXAwbggbwgNn4VuQx0X8CSfHnveyr+MwuUe2fzUDAsGQu3rVe9qZ1EwSNlx2wYJCKzU2v/1qvWUHgdK90FyTqHbzGFqfmVdPtzEw0bl/Jc5irtEo2WSwgZ3ePIOkWFymnTitF9GepWIxBrCYmRNnvtH8uDU1dA+8VtqdA67c=
Message-ID: <a8e1da0805191914v3ef4740qd99a5c2cc449444@mail.gmail.com>
Date: Tue, 20 May 2008 10:14:19 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Dave Young" <hidave.darkstar@gmail.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [2.6.26-rc2-mm1] sync to speed up?
In-Reply-To: <20080519230511.GL15035@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0805190015t2044c33ar4b7320d0a37d7e09@mail.gmail.com>
	 <20080519230511.GL15035@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 7:05 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, May 19, 2008 at 03:15:09PM +0800, Dave Young wrote:
>> Hi,
>>
>> With 2.6.26-rc2-mm1 I need to sync frequently. It's not normal as my
>> understanding.
>>
>> 1. scp a big file from a lan server. Firstly the speed is about 8M/s,
>> but the speed will slow down to 100K/s at last. After I exec "sync",
>> the speed will restore.
>>
>> Is this a known issue?
>
> Dave, what filesystem are you using?  Jiri's patch on this thread was
> to fix a problem in ext4, which means that's fixing a problem which is
> unrelated to the slow mkfs.ext2 problem (which is writing to a block
> device, not a file in a ext4 filesystem), and so it's likely unrelated
> to your problem (unless you're using ext4 and didn't tell us :-).

I'm using ext3. Jiri's patch fixes the my problem.  Seems the problem
is not related to filesystem.

>
> Andrew's probably right that it may be related to the slow mkfs
> problem.  Can you confirm that you are seeing this on 2.6.26-rc2-mm1,
> but not on stock 2.6.26.rc2?

I didn't notice same thing on 2.6.26-rc2, is it necessary for me to test on it?

Regards
dave
