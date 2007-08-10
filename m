Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbXHJW7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbXHJW7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXHJW7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:59:06 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:39922 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXHJW7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:59:05 -0400
Message-ID: <46BCECED.7050002@gmail.com>
Date: Sat, 11 Aug 2007 00:55:41 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matti Aarnio <matti.aarnio@zmailer.org>
CC: Vlad <vladc6@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Noatime vs relatime
References: <233939.75965.qm@web54403.mail.yahoo.com> <20070810151014.GT6372@mea-ext.zmailer.org>
In-Reply-To: <20070810151014.GT6372@mea-ext.zmailer.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2007 05:10 PM, Matti Aarnio wrote:

> On Fri, Aug 10, 2007 at 07:26:46AM -0700, Vlad wrote:
> ... 
>> "Warning: Atime will be disabled by default in future kernel versions,
>> but you will still be able to turn it on when configuring the kernel."
>>
>> This should give a heads-up to the 0.001% of people who still use
>> atime so that they know to customize this option or start using modern
>> file-monitoring techniques like inotify.
> 
> NO for two reasons:
>   - atime semantics are just fine in server environments
>   - inotify IS NOT scalable to millions of files, nor
>     to situations where we want to check alteration weeks
>     or months after the fact
> 
> In reality I would perhaps prefer mount-behaviour being altered
> from 'by default do atime' to 'by default do noatime.

I must say I've been wondering about relatime a bit as well. Are there 
actually users who do really want atime, but not badly enough to want real 
atime?

I've been running with noatime for years now and do not plan on changing 
that so have been shrugging this entire discussion off with "no care of 
mine", but whose care _is_ it?

> There MUST be an easy way to tell system that "yes, I want to track
> last accesstime."

mount -o atime. Or as far as I'm concerned, keep the default as posixly 
compliant as one wants and teach people and distributions to mount "noatime" 
as I hear some have already been doing. I may be wrong, but to me, relatime 
sounds like compromising for the sake of compromising...

Rene.

