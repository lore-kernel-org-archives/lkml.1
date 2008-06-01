Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYFAOrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYFAOrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYFAOp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:45:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:25280 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYFAOp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=koLF/wnEZglCV6XcwiMCDNStAvWxpWt3U68qi6Aep2aQfmCYXtABLBE5A+rMZcimTqc5WJ9wyZB6u8fazVElwvH8psolI9WnfURGwZN5FzNa96Z+sS/FEBZfAuXi9ss8F5t8K17yedB2XqxrR/17vcIo8nG8xQ9WJZFN4r5aQ/A=
Message-ID: <7b9198260806010745n7b9bc150u4c934eb4123ffda3@mail.gmail.com>
Date: Sun, 1 Jun 2008 15:45:57 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [RFC PATCH 2/2] xfs: Make XFS use the new file system init infrastructure
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080531071536.GA5405@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211737699-25615-1-git-send-email-tspink@gmail.com>
	 <1211737699-25615-2-git-send-email-tspink@gmail.com>
	 <1211737699-25615-3-git-send-email-tspink@gmail.com>
	 <20080531071536.GA5405@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/31 Pavel Machek <pavel@ucw.cz>:
> On Sun 2008-05-25 18:48:19, Tom Spink wrote:
>> This patch makes XFS use the file system type specific init and exit
>> callbacks, so that XFS only initialises when it's used for the first
>> time.
>>
>> This is useful for when XFS is compiled into the kernel, but never
>> actually used as it stops XFS from creating global threads, until
>> they are needed.
>
> Yes please. Removing gazillion kernel threads when xfs is unused is
> nice.
>
> You should probably have cced fsdevel and xfs lists?
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

Hi Pavel,

I'll re-send with those CC's!

-- 
Tom Spink
