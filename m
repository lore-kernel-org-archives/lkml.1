Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbXGBXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbXGBXOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbXGBXNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:13:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744AbXGBXNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:13:49 -0400
Message-ID: <468986A7.5030402@redhat.com>
Date: Mon, 02 Jul 2007 19:13:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Juan Antonio Martinez <jonsito@teleline.es>, linux-kernel@vger.kernel.org
Subject: Re: ppdev - libieee1284.so  conflicts with 2.6.21
References: <1183368129.4967.1.camel@drake.micasa.es> <20070702154753.56d06f10.akpm@linux-foundation.org>
In-Reply-To: <20070702154753.56d06f10.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2007 06:47 PM, Andrew Morton wrote:
> On Mon, 02 Jul 2007 11:22:09 +0200
> Juan Antonio Martinez <jonsito@teleline.es> wrote:
> 
>> I've reported this error to Fedora Bugzilla:
>>
>> http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246406
>>
>> In sort: to use libieee1284 I need to disable ppdev usage with
>> kernel 2.6.21. Kernel 2.6.20 works fine
>>
>> [root@drake char]# uname -a
>> Linux drake.micasa.es 2.6.21-1.3228.fc7 #1 SMP Tue Jun 12 15:37:31 EDT
>> 2007 i686 athlon i386 GNU/Linux
>>
>> By doing "echo disallow method ppdev > /etc/ieee1284.conf" everything
>> works fine on both kernels
>>
>> Seems affect several distributions, not Fedora specific:
>> http://bugs.archlinux.org/task/7438
>> http://sourceforge.net/tracker/index.php?func=detail&aid=1739643&group_id=29314&atid=395778
>> http://www.digipedia.pl/man/libieee1284.3.html
>>
> Can you test a kernel with this change applied?
> 
> --- a/drivers/char/ppdev.c~a
> +++ a/drivers/char/ppdev.c

He's reporting the bug against kernel 2.6.21, which does not have the
patch you are reverting applied.

ppdev hasn't changed in the six months prior to 2.6.21...
