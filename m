Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbXCJWrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbXCJWrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbXCJWq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:46:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:27992 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbXCJWq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:46:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=knbX0k1RTwsL/i1NjZSUo9mq21qqDBEmYMsl5vrhMAAN8AzDnbasynJ2zBxaTj9PlMsYclO3VkQKULOwSDdVK10yQ7pQCk5F91xQ9fL39/gQ3cG9612tannr7z4Okec3xl2RhB3K4oONxYfTbV8K69hd9L2qKPIyyWvQt+KFx3I=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Mockern@yandex.ru
Subject: Re: Problem: cat < /dev/my_ttyS0 is not blocked
Date: Sat, 10 Mar 2007 23:43:31 +0100
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <45F2A1B5.000006.27583@webmail15.yandex.ru>
In-Reply-To: <45F2A1B5.000006.27583@webmail15.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703102343.31135.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 13:16, Mockern wrote:
> I have a problem with  cat < /dev/my_ttyS0 (see strace output below).
> cat function is not blocked. I don't understand why it is not stopped
> at read(0, __  and terminated?  
> Thank you

Because /dev/my_ttyS0 is probaly a null file.

Please show output of 'ls -l /dev/*ttyS*'

--
vda
