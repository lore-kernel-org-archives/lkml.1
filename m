Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbXKBTOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbXKBTOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbXKBTOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:14:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:16392 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbXKBTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IhJ2xLMmwiVvmEcHKgdc0m4Lp1AYGbUTbUErejA/WpoC6lDg5J2EDeiIOfUu0YQliELB0Z9be3hM2Ya+RUfizJFn9XLwjSzW+XxGcIXTa2d8+SQynNHR1q8js2sfcniIG0k3cRkGyeQEdqX955Tx7JbWB4xZEkWJfIrA7BOj3NM=
Message-ID: <f158dc670711021214h1f9d6b80wf691fa08da1041d4@mail.gmail.com>
Date: Fri, 2 Nov 2007 13:14:05 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] 9p: basic sysfs support
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071102175151.GA32460@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071102165331.GA16063@ionkov.net>
	 <20071102175151.GA32460@kroah.com>
X-Google-Sender-Auth: a8ffeafb25905f8c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds only the basic 9p functionality, we use the sysfs
interface extensively for configuring the 9p in-kernel servers (patch
7 in the series). The v9fs filesyste will probably add some more
subdirectories for authenticating users and mapping user names to
uids...

Thanks,
    Lucho

On 11/2/07, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 02, 2007 at 10:53:31AM -0600, Latchesar Ionkov wrote:
> > This patch implements the basic sysfs support for 9p. If CONFIG_NET_9P_DEBUG
> > is defined, allows reading and modifying the debug level via
> > /sysfs/fs/9p/debuglevel.
>
> Since this is a debug-only type file, why not just put it in debugfs
> instead?
>
> And I have a huge patch-series pending that will make adding files like
> this to sysfs much easier in the future.  But nice job, it looks like
> you got it all correct, which is pretty hard to do first time these days
> due to the complexity of the current interface :)
>
> thanks,
>
> greg k-h
>
