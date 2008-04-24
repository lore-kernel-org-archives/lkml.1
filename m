Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYDXWEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYDXWEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYDXWEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:04:35 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:25058 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbYDXWEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=o/X2U0D++av79xywrdMBx0rIqDFy8dZhpF2reJb7zHEHDLyfKLVNsiRdin4qnxTgFTeUbLvw5Nhxs6JwIjPWVbI/iqJQAZ/HwSTsIgAxDF9m3jeMuylZRAQchR9FnCdwmNxWj31MWbUHPHPryaOaaHWIo1ND/F+utzYljTeknsc=
Message-ID: <ed038eb20804241504s17f7c0edu6ab0017e59fb7535@mail.gmail.com>
Date: Fri, 25 Apr 2008 00:04:33 +0200
From: "Carl Henrik Lunde" <chlunde@ping.uio.no>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <48109571.70905@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480F8936.5030406@hp.com> <87ve27gz4u.fsf@basil.nowhere.org>
	 <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk>
	 <48109571.70905@hp.com>
X-Google-Sender-Auth: 56517d806799307d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 4:13 PM, Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:
[...]
>  o  The kernel already exports stats on merges, so the daemon could watch
>  those stats in comparison to the number of I/Os submitted. If it
>  determined that merge attempts were not being very successful, it could
>  turn off merges for a period of time. Later it could turn them back on,
>  watch for a while, and repeat.
>
>  Does this sound better/worthwhile?

It may be more interesting to make a program which makes some helpful
suggestions
after looking at a blktrace file.  The program could for example
suggest changing
the I/O scheduler, increasing a parameter such as slice_sync, or disable merges.

-- 
Carl Henrik
