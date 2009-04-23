Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZDWLSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZDWLSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbZDWLSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:18:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31199 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbZDWLS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CvcQh/oE3tFO29XzBfdD8L8aXIYYOhhZd/hP2NmPNHiilgi+nAwI1aKz5npeJJR81Z
         EnTKMxUjpxEz73Rh2/CiXj9KRc//vo4I123CcI5RZqsWikG43e7lwIAFHRPV2iekxuMr
         Wun9o6aF77R69TTYmsmEIKPDL2pvHm69zCd2A=
MIME-Version: 1.0
In-Reply-To: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
References: <4e5e476b0904221407v7f43c058l8fc61198a2e4bb6e@mail.gmail.com>
Date: Thu, 23 Apr 2009 11:18:27 +0000
Message-ID: <4d8e3fd30904230418g20e89cb1se4303754914bbcd7@mail.gmail.com>
Subject: Re: Reduce latencies for syncronous writes and high I/O priority 
	requests in deadline IO scheduler
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: jens.axboe@oracle.com, Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/09, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> Hi,
> deadline I/O scheduler currently classifies all I/O requests in only 2
> classes, reads (always considered high priority) and writes (always
> lower).
> The attached patch, intended to reduce latencies for syncronous writes
> and high I/O priority requests, introduces more levels of priorities:
> * real time reads: highest priority and shortest deadline, can starve
> other levels
> * syncronous operations (either best effort reads or RT/BE writes),
> mid priority, starvation for lower level is prevented as usual
> * asyncronous operations (async writes and all IDLE class requests),
> lowest priority and longest deadline
>


numbers are impressive.

do you observe better latencies in normal desktop usage as well?

ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
http://mypage.vodafone.it/
