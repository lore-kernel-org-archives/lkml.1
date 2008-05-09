Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYEIWLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYEIWLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbYEIWLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:11:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:25613 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872AbYEIWL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=DocMH0MG4KHh7MmhV0YO212RfMxeH6ZWUqyr6UgS1d8JE7NOR4gRxiCIU+XY2681+sUm/7BfXbnTnMmWAGCFN5yXIcaMKamdtI850hFleFbYDCUfRrqktfb3lFFwyhXSHS1nsTY0qI2JJEHgCF0mCsbh2TUrUbQMgNjOP7nzR6Y=
Date: Sat, 10 May 2008 00:11:24 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: how to empty buffers/cache?
Message-ID: <20080510001124.6bc3a5c6@Varda>
In-Reply-To: <1210369787.4142.24.camel@localhost>
References: <1210369787.4142.24.camel@localhost>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 09 May 2008 21:49:47 +0000
Soeren Sonnenburg <kernel@nn7.de> escribió:

> Dear all,
> 
> I am trying to perform some benchmarks that involve reading the same big
> file a couple of times from disk. However I would want to make sure that
> the file is not buffered/cached by the kernel when I read the file a
> second/third/etc time.
> 
> Is there a way (except rebooting/unmounting the disk) to clear the
> buffers?

 echo 3  > /proc/sys/vm/drop_caches IIRC

> 
> Thanks,
> Soeren
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
