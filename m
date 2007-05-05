Return-Path: <linux-kernel-owner+w=401wt.eu-S933638AbXEEVJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbXEEVJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbXEEVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:09:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:58824 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638AbXEEVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hV27tPyAlvgcSz7mPzTt/wRWhStHaVdrLunZ6CEvFYo0RhE/gSDA1zml3so7JKlDFK2VsRUq7k3ZUeWQzkC0kCFiNnHKVdockaowfhxx+ZvBpDSY3jWGY2mIrfM9Z55TazL+eAvthDo/jzHePGIUZ4RXotOs7nEKc+1p4JOQTaY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH pata-2.6 fix queue] hpt366: don't check enablebits for HPT36x
Date: Sat, 5 May 2007 23:20:16 +0200
User-Agent: KMail/1.9.6
Cc: michal.kepien@poczta.onet.pl, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200705042318.37367.sshtylyov@ru.mvista.com> <200705052130.53793.bzolnier@gmail.com> <463CE681.9050000@ru.mvista.com>
In-Reply-To: <463CE681.9050000@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705052320.16144.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2007, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>HPT36x chip don't seem to have the channel enable bits, so prevent the IDE core
> >>from checking them...
> 
> >>Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> > applied
> 
>     I'm getting "403 Forbidden" trying to browse this patch (and 
> ide-cs-recognize-2gb-compactflash-from-transcend.patch as well).

Should be fixed now - sorry for that.

While at it I replaced mine version of "the hpt366: simplify UltraDMA
filtering (take 2)" with the official one ;) and fixed my damn scripts
to always do "chmod 644 pata-2.6/patches/*.patch" before pushing updates
to kernel.org.

Bart
