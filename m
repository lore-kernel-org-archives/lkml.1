Return-Path: <linux-kernel-owner+w=401wt.eu-S965440AbXECHbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbXECHbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXECHbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:31:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:49218 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440AbXECHbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=nqL9LRmMugmPAPYtoCQsZZR8eZSfETD6X8zUsbhfGoTOJWvb6ONnRPElEJkWCOABP3mdEzY2QW+CYT0HJYtcDmwfUzi344lzHZ5EGjLEJP2FEpUgCyMLE5jNUsJWhH5dqsdUeGCTqMTa5pLfyoZ2AiJvoEqUmtugDl5/KHWHMz0=
Message-ID: <46398FCF.80100@gmail.com>
Date: Thu, 03 May 2007 11:31:27 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Execute in place
References: <200705030211.36293.a1426z@gawab.com>
In-Reply-To: <200705030211.36293.a1426z@gawab.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Hugh Dickins wrote:
>> On Wed, 2 May 2007, Phillip Susi wrote:
>>> Hugh Dickins wrote:
>>>> tmpfs doesn't store its stuff in the page cache twice: that's true,
>>>> and I didn't mean to imply otherwise.  But tmpfs doesn't contain any
>>>> support for rom memory: you'd have to copy from rom to tmpfs to use
>>>> it.
>>> The question is, when you execute a binary on tmpfs, does its code
>>> segment get mapped directly where it's at in the buffer cache, or does
>>> it get copied to another page for the executing process?  At least,
>>> assuming this is possible due to the vma and file offsets of the segment
>>> being aligned.
>> Its pages are mapped directly into the executing process, without copying.
>
> Thank GOD!  Boy, was I worried there for a second.
>
> Now, if there were only an easy way to make tmpfs persistent?
>
>

It would be not a tmpfs (*temporary* fs)then, but something like this

http://pramfs.sourceforge.net/



Regards,
Dmitry

