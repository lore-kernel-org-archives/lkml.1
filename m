Return-Path: <linux-kernel-owner+w=401wt.eu-S935439AbXGYTk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935439AbXGYTk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760487AbXGYTkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:40:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:22680 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbXGYTkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:40:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WcOqVI31YYQPXd1oo3NQt0ATC6KyPEDJ+bMYpQaBpZH6+HaBFsnVIAbE2PubxNEpC9VFFPuryeBJcrYmLqVO5VUzMnVd0VBCBBcrBMJl/H6qe7hx3TZrLyYMpMcCQ8TJqCEI1zXZDQNFtW+PLS73KQ9IGrRm5s6Ra9NpoPlCqzY=
Message-ID: <82e4877d0707251240t4c5dcff7wb3c7523e577ddb76@mail.gmail.com>
Date: Wed, 25 Jul 2007 15:40:11 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: 2.6.22 - Suspend and Weird Load Averages
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Nigel Cunningham" <ncunningham@linuxmail.org>
In-Reply-To: <20070725133919.GA9256@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469E1AFE.7010108@gmail.com> <20070725133919.GA9256@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel!

On 7/25/07, Pavel Machek <pavel@ucw.cz> wrote:

> Known, and Rafael/Nigel have patches to fix that.

Thanks for the info - Rafael/Nigel do you have any patches for me to
try/modify - I am just curious to see what approach the patches take
to fix this - I had started thinking about TASK_SUSPENDED which would
be equivalent to TASK_UNINTERRUPTIBLE for all purposes except load
calculation (not counted in nr_uninterruptible) but somehow I think
there might be a less intrusive / more correct way to do this.

>
> OTOH I'm not sure it is a problem -- lets just say that suspend is
> hard work and therefore it raises load avg?
>                                                        Pavel

Hehe, nope - that would be inefficient suspend for me! Any way I
understand it's purely a cosmetic problem but if we could be
cosmetically correct to report the right uptime after suspend sans the
sleep time (unlike other OSes which include sleep time when reporting
it) I think we should also fix this one to report correct load
averages.

Cheers

Parag
