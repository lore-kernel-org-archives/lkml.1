Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZEZJCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZEZJCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZEZJC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:02:27 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:2159 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZEZJC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y0OyQzly7L3m1GvUgssQTZBr3oYStxnDCvIcmAKVAKfZs95mgRpjaB9w7NupquxAez
         Gp3KuKE2IsMIRLl7ogxG5/jCCVs51x0St4obDJyRqDvulONTD35HBkG0H30x1mnnzpL0
         YfJ4mfEx9eFY6rJZ9iVFkYbfPcA15DdQO1jYw=
MIME-Version: 1.0
In-Reply-To: <1243236668-3398-14-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
	 <1243236668-3398-14-git-send-email-jens.axboe@oracle.com>
Date: Tue, 26 May 2009 14:32:27 +0530
Message-ID: <807b3a220905260202u11a9a9f8wd1874fce82d6b313@mail.gmail.com>
Subject: Re: [PATCH 07/13] block: avoid indirect calls to enter cfq io 
	scheduler
From: Nikanth K <nikanth@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Nikanth Karthikesan <knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 1:00 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> They can be expensive, since CPUs generally do not branch predict
> well for them.
>

Cant gcc take care of this? Comparing a pointer and then calling the
function directly without using the pointer! Wont this increase the
text size of the kernel and possibly degrade performance? Do you have
any measurement of the improvement? Is this kind of optimization being
used elsewhere?

Thanks
Nikanth
