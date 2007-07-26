Return-Path: <linux-kernel-owner+w=401wt.eu-S936449AbXGZUBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936449AbXGZUBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936163AbXGZT7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:59:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63144 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936138AbXGZT7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=XK8T+0EMqx+4UNJsBiIwFJQl+BjaxfcU7iN5eFFVXEr/Gm8VHC1nIgmEKrBbobNXbJb1i+AHuhP7/4huRxOwY8r9IvhEjeJMjqhDsiE/YQP1q14AfzhvzEielHJxsw3GD58ETTvUFkl9MTJVjUjzmLRUZxIUU74K9rhBCb7nSUw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: CONFIG_IDE_PROC_FS: /sys is not full replacement of /proc
Date: Thu, 26 Jul 2007 21:40:22 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200707180742.42651.arvidjaar@mail.ru>
In-Reply-To: <200707180742.42651.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707262140.22276.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 18 July 2007, Andrey Borzenkov wrote:
> May be I miss something obvious but most information that was available 
> in /proc/ide is missing under /sys. At the very least, Mandriva hardware 
> detection expects /proc/ide/hdX/model; nothing close is under /sys.

It is really better to obtain some information using IOCTLs (i.e. SMART
data) but for other like "model" it makes perfect sense to add them to /sys.

> Are there any plans to extend IDE /sys interface to provide full range of 
> information from /proc? Alternatively I appreciate description (or pointer to 
> thereof) how to get information that was available under /proc/ide 
> without /proc/ide :)

Could you please add the information that you find missing to the existing
infrastructure in ide.c (ide_dev_attrs[] table)?

Thanks,
Bart
