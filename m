Return-Path: <linux-kernel-owner+w=401wt.eu-S1945934AbXDCUrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945934AbXDCUrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945932AbXDCUrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:47:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945934AbXDCUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:47:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=mTWdiW8tUZCx9SdSdOI1j03SNgRiaFr5CBBOgVDUV0oJgi9MmmVJDvONMP0fUtaBE
	D0tG0nLg+/HhBTNUFOp+Q==
Message-ID: <4612BD12.4000905@google.com>
Date: Tue, 03 Apr 2007 13:46:10 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Martin Bligh <mbligh@google.com>, Rohit Seth <rohitseth@google.com>,
       viro@ftp.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix sysfs_readdir oops (was Re: sysfs reclaim crash)
References: <20070319140238.cbf28b2b.akpm@linux-foundation.org> <20070321134654.5wkqpfbpk0ggwks8@imap.linux.ibm.com> <20070321182123.GA12602@in.ibm.com> <20070323043047.GA5641@in.ibm.com> <20070322210504.3b052139.akpm@linux-foundation.org> <46042DDF.5060000@google.com> <20070324030535.GA8874@in.ibm.com> <20070403073830.GA9796@in.ibm.com>
In-Reply-To: <20070403073830.GA9796@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maneesh Soni wrote:
> I have modified the previous patch (which was dropped from -mm) and now keeping
> the statement making s_dentry as NULL in sysfs_d_iput(), so this should
> _safely_ fix sysfs_readdir() oops. 
>   

    If you could find some additional places in sysfs code to add new
BUG() checks I'd appreciate it. Especially if it turns out that you
can't reproduce it, I'd like to have as many asserts as is reasonable.
    -- Ethan

