Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbXHZPvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbXHZPvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 11:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXHZPvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 11:51:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30292 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbXHZPvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 11:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ud7YxdbtRcDnGWrJS2BQdXJPy3TDXIYmr/8QAYX2gxcW3KzxqAozeUY7qS+szkDZ31MQ/vUlhv79VvoMMtcRDagY34cQj7nwB9Tno53wEn1RmvAcjnxk6plsx9s6KUhAncmmR19eOMiGst7rqo7jMj/3TG+RdrOBvCoXCqmb3so=
Message-ID: <466ad3f90708260851u5d8ac58duc4072b71ebf78fc8@mail.gmail.com>
Date: Sun, 26 Aug 2007 11:51:48 -0400
From: "Fred Tyler" <fredty8@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Fred Tyler <fredty8@gmail.com> wrote:
> I think I've come across a memory leak in 2.6.20. I've upgraded to the
> latest 2.6.20.17, but it didn't seem to help.

Sorry to keep replying to my own post, but further investigation
suggests that the memory losses may be occurring at times of heavy
filesystem access. The machines in question run rsyncs of hundreds of
thousands of files every few hours, and I'm starting to think that the
memory loss occurs during these times. I don't know how I'd go about
proving this though...
