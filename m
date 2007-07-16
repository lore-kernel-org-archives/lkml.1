Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXGPQ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXGPQ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbXGPQ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:28:23 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:25477 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570AbXGPQ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TPbyRBJaasb8n+hLCNZEIqc2Wfws4i25zA5lhJcfa8hpdjvHy2qEmy1Q66ZjlSi0yL05tZlmw3yK6JZ8GzNMyKW/v8Oq5CVuPJeKrUxnSGcxb0kCJh4IhC934WS8aQh6zit18ScCsQMlG8JPJNqEpYl1qEHtjNKeO2uSJrxEk4M=
Message-ID: <961aa3350707160928w6c1e8b28l9750cfaa6a08d9d0@mail.gmail.com>
Date: Tue, 17 Jul 2007 01:28:20 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 3/10] sysfs: fix error handling in create_files()
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20070716172945.54e07c3c@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716134855.GA1858@APFDCB5C> <20070716135230.GC2040@APFDCB5C>
	 <20070716172945.54e07c3c@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/17, Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Mon, 16 Jul 2007 22:52:30 +0900,
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> > Current error handling in create_files() attempts to remove
> > all attributes passed by argument by remove_files(). But it should
> > only remove the attributes that have been successfully added.
>
> While this is certainly cleaner, a question out of curiousity: Does
> this fix any problem you saw? sysfs_hash_and_remove() used to be safe
> on non-existing attributes...

Maybe I folded all suspicious bugfixes that I found while I spend a lot of
time to pass my cpu hotplug/unplug test script.

I'll test again without this patch.
