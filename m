Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYCTI0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYCTI0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 04:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYCTI0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 04:26:38 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:57031 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYCTI0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 04:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JGfGBS/V9oK/GOzQrz9X022XFF+1lmuW8lGj0gcCJYzLz2Z3usA1zCEHCY7ws94N8QGuzFH9hJ35Q9VGJejyTLG0GS6S5VnQdcllUWr+8sZgBX+8Mf8XMgQI/6xAkxBlENuhmQ/8splK+VOeh9hG2+1/i4NxbdgIg3fL7CwDiX4=
Message-ID: <939d53060803200126k563b9ae7l7197dea4e96ba1ed@mail.gmail.com>
Date: Thu, 20 Mar 2008 09:26:35 +0100
From: "Benjamin Thery" <ben.thery@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command as non-root
Cc: akpm@linux-foundation.org, tilman@imap.cc, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, pekkas@netcore.fi, yoshfuji@linux-ipv6.org,
       dlezcano@fr.ibm.com, xemul@openvz.org, rjw@sisk.pl,
       ebiederm@xmission.com
In-Reply-To: <20080319.154947.78332548.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D98510.60801@imap.cc>
	 <939d53060803191052o2f43b75cu426d51f9f24e2a46@mail.gmail.com>
	 <20080319141608.ede86a86.akpm@linux-foundation.org>
	 <20080319.154947.78332548.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 11:49 PM, David Miller <davem@davemloft.net> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
>  Date: Wed, 19 Mar 2008 14:16:08 -0700
>
>
>  > Although this is advertised as a 2.6.25-rc5-mm1 problem, I assume the
>  > regression is also in mainline? 2.6.25-rc6?
>
>  It is in 2.6.25-rc6, correct.
>
>  If Pavel or someone else doesn't produce a good fix soon
>  I'll revert the guilty change as this bug is worse than
>  the problem that changeset fixes.

Andre Noll sent a patch to LKML, acked by Pavel:

"Fix permissions of /proc/net"
http://thread.gmane.org/gmane.linux.kernel/655148

Benjamin
