Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXCDBQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXCDBQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932395AbXCDBQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:16:12 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:49639 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbXCDBQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:16:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ULI/6Dt8lVvcqfuKrWbOoTha3O3Oo59+3AcvdVhJt4s13qGRMMjEfeHY9U4ZtJ7V4GoEWIDdzqcEM8VP1J91WitDZIZoOMkzfT7hzgK1cOrAaIwysmJP1XawtWlDw71KsY0l3VQy/gI6f2vTxJa3N6d1NIq0T1iQWiuENpfexUc=
Message-ID: <75b66ecd0703031716k5b9fd96br9ecd93f1fc3a6032@mail.gmail.com>
Date: Sat, 3 Mar 2007 20:16:09 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: userspace pagecache management tool
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070303122935.f1ab0067.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
X-Google-Sender-Auth: 6452995404e36068
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> The tool uses an LD_PRELOAD hack to intercept glibc's read(), pread(),
> write(), pwrite(), close() and dup2() functions.  pagecache control is done
> via posix_fadvise() and sync_file_range().
>

How could this have any effect on the updatedb problem?  updatedb does
not read() anything, it just open()s and stat()s every file on the
disk.

Lee
