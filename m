Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXC2E7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXC2E7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 00:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964838AbXC2E7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 00:59:49 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:47455 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964784AbXC2E7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 00:59:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Z4VermDkNvChd4ToNlGU3hXCLbtzgy1Plpm+8yaDzwIKmQF8tUk/n6n/qMMI5ndUeXAuMRV2LJQlCML+1T1snje+DifQF26M39pgIf9Yo29RcvQmyJ/OWFpJsL3aVR/kM4AVvHkApnZiAwm193F8Rw4ASwIG746hbpMmeMb42eM=  ;
X-YMail-OSG: GlxwV6cVM1nFDrbKvEqnScYM6vkrsPtWJV_szUbyHp_XD.sIsTw5_syGnKLnJIY5A5Ry3FzkV1hVQHnnfi4DBv2tj7qlDGjJf4ZdOL6z_Dw6Sb1p1wg-
Message-ID: <460B47BE.5080502@yahoo.com.au>
Date: Thu, 29 Mar 2007 14:59:42 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: linux@horizon.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, miklos@szeredi.hu
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <20070328095014.20945.qmail@science.horizon.com>
In-Reply-To: <20070328095014.20945.qmail@science.horizon.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com wrote:
>>But if you didn't notice until now, then the current implementation
>>must be pretty reasonable for you use as well.
> 
> 
> Oh, I definitely noticed.  As soon as I tried to port my application
> to 2.6, it broke - as evidenced by my complaints last year.  The
> current solution is simple - since it's running on dedicated boxes,
> leave them on 2.4.

Well I didn't know that was a change in behaviour vs 2.4 (or maybe I
did and forgot). That was probably a bit silly, unless there was a
good reason for it.

-- 
SUSE Labs, Novell Inc.
