Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbZKGQVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbZKGQVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 11:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZKGQU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 11:20:59 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:59658 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZKGQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 11:20:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NC6+/90f0kO2nTGWuF4i2TyJmFT7+aq/ZddYAuepdNM9X6oJT7ha0ONUIMDye2f2s8
         NsawG574ibupMtK0nDHzvFwzF4zfzsYg9dnkxXKLNu3Rdlqv2kU3DyYMj6bjdV01DtCM
         NrKjE5Sw0Brpqmib57jfTVqfimfZXcOTo1xmM=
Message-ID: <4AF59F24.4010501@gmail.com>
Date: Sat, 07 Nov 2009 12:24:04 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Intermittent early panic in try_to_wake_up
References: <4AE0EBBD.6090005@gmail.com>	 <1256289781.22979.11.camel@marge.simson.net>  <4AF36364.9090004@gmail.com>	 <1257485650.6233.17.camel@marge.simson.net>  <4AF4B614.3080708@gmail.com> <1257569157.6390.5.camel@marge.simson.net>
In-Reply-To: <1257569157.6390.5.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Fri, 2009-11-06 at 19:49 -0400, Kevin Winchester wrote:
> 
>> The patch below does not apply to mainline, unless I'm doing something wrong.
>> It's against -tip, I assume?  Is it just as applicable to mainline?
> 
> It was mainline, but I had the scheduler pull request and another in for
> testing as well.  Linus has pulled, so it'll apply now, with offsets.
> 

It did end up applying, but did not have any effect.  Looking at the patch
again, I see that it appears to only affect CONFIG_SMP, which I am not
running (and in fact it adds a build warning for the !SMP case).  So there
was not much chance of it fixing anything, I suppose.

Any other ideas?  I don't have a serial console, and the trace scrolls off
my console, so I don't know if any debug printks would help.  Would it help
if I copied the entire panic message entirely, including the Code section?
I can try that the next time it happens.

-- 
Kevin

