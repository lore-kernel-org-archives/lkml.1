Return-Path: <linux-kernel-owner+w=401wt.eu-S934150AbXC0S2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150AbXC0S2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934148AbXC0S2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:28:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:53637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934150AbXC0S2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:28:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=VzbsMZUu5qhrfSsbThQHToby+qwBHwkugG+5ReGXYskKmFNiQj9ODK1V7/1M/3Qg6
	IQljth7c9gqneyJL7JJCg==
Message-ID: <46096202.6080205@google.com>
Date: Tue, 27 Mar 2007 11:27:14 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Martin Bligh <mbligh@google.com>, Rohit Seth <rohitseth@google.com>,
       viro@ftp.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs reclaim crash
References: <20070319140238.cbf28b2b.akpm@linux-foundation.org> <20070321134654.5wkqpfbpk0ggwks8@imap.linux.ibm.com> <20070321182123.GA12602@in.ibm.com> <20070323043047.GA5641@in.ibm.com> <20070322210504.3b052139.akpm@linux-foundation.org> <46042DDF.5060000@google.com> <20070324030535.GA8874@in.ibm.com>
In-Reply-To: <20070324030535.GA8874@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Maneesh -- I will start testing with the patch you provided. If you 
come up with any further issues please let me know. Also, if you could 
suggest some additional BUG() lines that I could insert I would 
appreciate it. Since the bug is hard to reproduce, it may be easier to 
catch a race condition in the making via BUG() than an actual failure 
due to a race condition.

	Thanks!
	-- Ethan
