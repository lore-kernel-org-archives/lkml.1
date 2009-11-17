Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZKQKUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZKQKUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZKQKUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:20:18 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:63673 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZKQKUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:20:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RCImGO7uGsEFE4tMLuuCesnZJ5u0ijEKDUE462GLb0uZKQQfXjyipABoKLAfmPHoUM
         s05Ky14MRsw6pf//blsTPIUGaYH7EHzvQRcnFxVjSe/0y9pyNAs3cMe5QWzisjLVL9VV
         3foYAZgvHrIqV28zzi6zvVabJkG5HUfseQ7ac=
Message-ID: <4B0278D9.6030806@gmail.com>
Date: Tue, 17 Nov 2009 05:20:09 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: huananhu@huawei.com
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
References: <faf197be196ee.196eefaf197be@huawei.com> <20091117.012248.86306050.davem@davemloft.net>
In-Reply-To: <20091117.012248.86306050.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Your patch is broken, please don't wate my time like this.
> 
> + git apply --check --whitespace=error-all diff
> error: patch failed: drivers/net/ppp_async.c:36
> error: drivers/net/ppp_async.c: patch does not apply
> 
What David may have meant, had he followed Documentation/ManagementStyle
or had any project management skills what-so-ever, is that you need to
follow Documentation/SubmittingPatches more carefully.

Look at 15) The canonical patch format

[PATCH 17/11] makes no sense, you don't have 11 patches, and the 17th
patch of 11 can never exist.

Need a better "subsystem: summary phrase", perhaps
   "net: PPP buffer too small for higher speed connections"

A marker line containing simply "---".

And your trailer boilerplate badly breaks the system, because it's
missing the SMTP email standard "--" line in front of it.

You'll get nicer formatting with 'git format-patch -o ~ HEAD~1' after you
do a 'git commit -a' on your git tree.

It takes some time, even for a simple 1 line fix like this....

Hope that helps.
