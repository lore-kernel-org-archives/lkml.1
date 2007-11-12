Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbXKLPXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbXKLPXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXKLPX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:23:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:10373 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXKLPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:23:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gnUv/Nw8C9AWcNpeCSUoZSzNQg7Q1tJRA89/fdTUgO4q5NoGLj22nYQ5NavsmM3xmhxUQFvSB6zRIZ2jsyK6OOpIpljzNEnBW7bwcXcxYrXqvYgyapzOs4KI0JNhJszAuZ4jxFXaVAJWiOo70IUBVoW4QnVW6+qX0l0cC8RzIGQ=
Message-ID: <47386FE4.3080907@gmail.com>
Date: Tue, 13 Nov 2007 00:23:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Will Trives <will@trivescon.com.au>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: cd/dvd inaccessible in 2.6.24-rc2
References: <1194668831.3436.14.camel@Athas>  <47364059.8000003@garzik.org>	 <1194756033.5042.15.camel@Athas> <1194847209.5012.2.camel@Athas>
In-Reply-To: <1194847209.5012.2.camel@Athas>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will Trives wrote:
> Hello,
> 
> 
> My mistake, it looks like the issue is to do with writing only.
> 
> Mounting a standard DVD works fine with 2.6.24-rc2-git2.
> 
> As soon as I try to use wodim or load k3b, that's when drive gets locked
> up.
> 
> The issue was still there with 2.6.23-git15 , I will continue to test
> with previous ones.

I think I now know what's wrong with all these ATAPI issues.  I'm
working on generic solution.  Please standby a bit.

Thanks.

-- 
tejun
