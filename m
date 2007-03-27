Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXC0RA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXC0RA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbXC0RA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:00:57 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:16906 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbXC0RAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k6iPIsvyqu5fPDSga60vjhtQOl5/ExhqT5ln9f1BggfgdbYpaRQ2W4nIK717DnoMIjohmAlrOW3qyNf8tBeOFmFvDTUY0iqiw0KxQHvfkM41v4kQ7Xxe4g3HzneNgZJB53im/xuH0EBKLvKzECFdG3068u7w/AYRNgfqyffBOTE=
Message-ID: <8bd0f97a0703271000x2910b2fan573fd37bb45a058d@mail.gmail.com>
Date: Tue, 27 Mar 2007 13:00:54 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Andrew Morton" <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, "Hugh Dickins" <hugh@veritas.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <27782.1174989913@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI>
	 <20070326024143.a226c9b2.akpm@linux-foundation.org>
	 <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com>
	 <6791.1174909459@redhat.com> <11045.1174911764@redhat.com>
	 <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI>
	 <22674.1174915478@redhat.com>
	 <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com>
	 <27782.1174989913@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, David Howells <dhowells@redhat.com> wrote:
> Note that it's not possible to shift windows around in response to faults
> because fault reporting is asynchronous - the entire remaining instruction
> queue will be executed *before* the exception is actually raised to the
> kernel.

ah that would limit the usefulness of its application in the kernel
... thanks for the info

> That sounds reasonable.  However, I suspect that most NOMMU CPUs won't be able
> to do that.  In effect you're creating a third option, I think (MMU, NOMMU,
> MPU).

sure, but i'm not sure the MPU option would be mutually exclusive with
NOMMU ... in the Blackfin case, we'd want both ...
-mike
