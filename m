Return-Path: <linux-kernel-owner+w=401wt.eu-S1751213AbXBMJKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbXBMJKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbXBMJKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:10:04 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:34649 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXBMJJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:09:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S51e6NEes4m1FBBIv/Mr9wbKgyazRLIWkGCJdKEdfJy71AFbUcqdDigC38twRraRKyXXtCwAtSD1l/tiXqPOfbSyCbN7WEuIBR2k88TeOJXFk5JhpS8Ljw/Q3FjVzT01la32uhJSBWZgPCeH9Ao/+WisfbEBWCRqn6JO0c+ylsY=
Message-ID: <b6a2187b0702130109n16cea6a1oae5761707c17e10f@mail.gmail.com>
Date: Tue, 13 Feb 2007 17:09:46 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] nanosecond filesystem support???
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Miquel van Smoorenburg" <miquels@cistron.nl>,
       "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <200702130952.26048.andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702131627210.5124@boston.corp.fedex.com>
	 <200702130952.26048.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Arjan van de Ven <arjan@infradead.org> wrote:
> it was there to avoid the following situation:
> on disk it's still in seconds


On 2/13/07, Andi Kleen <andi@firstfloor.org> wrote:

> If you want ns resolution you need a file system that supports it:
> that's currently XFS, JFS, NTFS/CIFS (resolution is lower, but < 1s), NFSv[34], UDF,
> with suitable servers,  tmpfs/ramfs/hugetlbfs. ext4 ns support is being worked on,
>
> BTW the real max resolution supported in the kernel right now is jiffies.


Andy, Arjan,

Ok, I got it now. Well, after reboot, I ran stat() and since the info
has to come from disk, now the nanosec returned is zero!

Thanks for all your help.

Jeff.
