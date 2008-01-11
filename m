Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYAKJV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYAKJV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYAKJVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:21:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:56133 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYAKJVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=qUyC/dmkHkzCl2S21OtWvYJhhgABZXnf9eVIT7zKvVy2bqiyLSgCoj7Tqkf3PXB1k1Vw141J/KxY2ZOeDsmvBeEODEWAaoYHCMskLKTRdti8JCQWaDJ+Ug8sVtd7yeCHXQlJfZd76O0cgJZRwlBkxPXbEJBXLnZhttbQN9A9cJg=
Message-ID: <47873505.7040008@gmail.com>
Date: Fri, 11 Jan 2008 10:21:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: apw@shadowen.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch.pl: allow piping
References: <20080111041120.085610726@mvista.com>	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>
In-Reply-To: <1200043035.29897.62.camel@imap.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 10:17 AM, Daniel Walker wrote:
> On Fri, 2008-01-11 at 09:52 +0100, Jiri Slaby wrote:
>> On 01/11/2008 05:10 AM, Daniel Walker wrote:
>>> A little feature addition to allow checkpatch.pl to check patches piped
>>> into it, in addition to specific file arguments.
>> You can still add - as an argument to check stdin. In which way is this better?
> 
> There's was no reason to limit the arguments ..
> 
> I was using it to do something like the following ,
> 
> git show 9914cad54c79d0b89b1f066c0894f00e1344131c | ./scripts/checkpatch.pl

Ok, and if you add a - there, it should have the same effect, but for free, 
doesn't it:
git show 9914cad54c79d0b89b1f066c0894f00e1344131c | ./scripts/checkpatch.pl -

regards,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
