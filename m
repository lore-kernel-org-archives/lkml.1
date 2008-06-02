Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbYFBNjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbYFBNjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYFBNjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:39:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:19284 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbYFBNjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z0WyMe+xk0SovtBvuY6D1d+CNYCCLsyIfAMtJ9WvNAAtIIW+0kib0wwAbXkwvDhKHv8E3tDsGQEl8IitfyFXwoq+XIUG6acbvlksPzu/fGiQoCy52F/IAlEFoM2ntxL4lJbO8+APG43kQ5B3ZFKaDWo4mE6CiKcSSQZo7QKcwTU=
Message-ID: <7b9198260806020639n7679035s270c0ce3575a894b@mail.gmail.com>
Date: Mon, 2 Jun 2008 14:39:40 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Tom Spink" <tspink@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [RFC PATCH 0/2] On-demand Filesystem Initialisation
In-Reply-To: <20080602015831.GB2428@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212331915-22856-1-git-send-email-tspink@gmail.com>
	 <20080602015831.GB2428@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/2 Dave Chinner <david@fromorbit.com>:
> On Sun, Jun 01, 2008 at 03:51:53PM +0100, Tom Spink wrote:
>>
>> (resend to include CCs)
>
> What cc's? Still no xfs cc on it. I added it to this reply....
>
>> This (short) patch series is another RFC for the patch that introduces on-demand
>> filesystem initialisation.  In addition to the original infrastructure
>> implementation (with clean-ups), it changes XFS to use this new infrastructure.
>>
>> I wrote a toy filesystem (testfs) to simulate scheduling/allocation delays and
>> to torture the mount/unmount cycles.  I didn't manage to deadlock the system
>> in my tests.  XFS also works as expected aswell, in that the global threads
>> are not created until an XFS filesystem is mounted for the first time.  When the
>> last XFS filesystem is unmounted, the threads go away.
>>
>> Please let me know what you think!
>
> Why even bother? This is why we have /modular/ kernels - if you're
> not using XFS then don't load it and you won't see those pesky
> threads. That'll save on a bunch of memory as well because the xfs
> module ain't small (>480k on i386)....

Yeah, absolutely.  But if the filesystem is built-in, you can't unload it.

> Cheers,
>
> Dave.

Thanks for taking a look, anyway!

-- 
Tom Spink
