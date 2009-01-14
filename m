Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbZANCTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbZANCTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZANCSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:18:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:39339 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbZANCSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:18:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:organization:
	user-agent:x-gmailtapped-by:x-gmailtapped;
	b=k6OcCDnVQka/aPMAVyrI6HepTqtmAb6VjuLXG/2r7e4ud4V5wSomGp5tyDwepywoq
	vgfhiEkBQvud36vn2qSfQ==
Date: Tue, 13 Jan 2009 18:18:01 -0800
From: Brian Swetland <swetland@google.com>
To: Greg KH <greg@kroah.com>, arve@google.com
Cc: San Mehat <san@android.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090114021801.GA14759@bulgaria.corp.google.com>
References: <20090114010223.GA21380@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114010223.GA21380@kroah.com>
Organization: Google, Inc.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: swetland
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looping in Arve who wrote the low memory killer and can explain things
in more detail.

Brian

[Greg KH <greg@kroah.com>]
> Hi San,
> 
> Alan Cox pointed me at the /proc/<pid>/oom_adj file that controls the
> oom-killer score for any process as being more than sufficent to control
> the oom killer.
> 
> This makes me wonder why you wrote the android lowmemlorykiller driver?
> 
> What is that driver for that is not already present in the existing
> oom_* values for every process?
> 
> thanks,
> 
> greg k-h
