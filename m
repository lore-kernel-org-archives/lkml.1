Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYAIPbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYAIPbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYAIPbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:31:38 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:18072 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYAIPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:31:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s6VaCPDY2vnQa0ySYFcg3wqJnID7F6WE2tm/EH2lyUxylmAPAeywrRmpwL8eTazcsbl1UMqK9z2JCPvFeNhx2EyQeYr0ENnJfM/vMpynPTCD5O1+70ZXf2LV91b5lCGE/0L1vuUQXL4z7dbUFaMyZjwYQITwIfxckbLxr/AE9/A=
Message-ID: <4df4ef0c0801090731k505c9efds56fe38b7a284446@mail.gmail.com>
Date: Wed, 9 Jan 2008 18:31:33 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, joe@evalesco.com
In-Reply-To: <9a8748490801090641s41a06c1era3764091f135567d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199728459.26463.11.camel@codedot>
	 <4df4ef0c0801090332y345ccb67se98409edc65fd6bf@mail.gmail.com>
	 <9a8748490801090641s41a06c1era3764091f135567d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/9, Jesper Juhl <jesper.juhl@gmail.com>:
> I've only looked briefly at your patch but it seems resonable. I'll
> try to do some testing with it later.

Jesper, thank you very much for your answer!

In fact, I tested my change quite extensively using test cases for the
mmap() and msync() system calls from the LTP test suite. Please note
that I did mention that in my previous message:

>>>

Additionally, the test cases for the msync() system call from
the LTP test suite (msync01 - msync05, mmapstress01, mmapstress09,
and mmapstress10) successfully passed using the kernel
with the patch included into this email.

<<<
