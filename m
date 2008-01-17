Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbYAQVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbYAQVwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbYAQVwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:52:21 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:51165 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbYAQVwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:52:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IuRW5oSOv4q41kgvurz2BCAZ7u0kjPSbtqu9zHudXW63P7UDedrlY22kDRtJVvzsDwVWIjVyhCF6DCCJopBF9MiXEw47HsjDtPQyZMK7I3FKNhXdKQNvESPFfP/+p9gTd3KhVqfgO58YYtc/k8GOYG5EBcoAWQeAhG2QD1Cgog4=
Date: Thu, 17 Jan 2008 22:55:48 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Dave Young <hidave.darkstar@gmail.com>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080117215548.GA2905@ami.dom.local>
References: <20080117194728.GA2598@ami.dom.local> <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org> <20080117211101.GA11853@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117211101.GA11853@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 01:11:01PM -0800, Greg KH wrote:
...
> I've known Greg to make lots of mistakes :)

Right! Above is one example...

> I don't remember ever saying that the "code is correct with the lockdep
> warnings", I think I said, "Make sure there are no lockdep warnings with
> any conversion you do."

I've meant your discussion with David Miller, where you doubted the need
to change properly working code. But, as a matter of fact, I really can't
see any reason to doubt this, and care so much about lockdep now, if there
are no known problems with lockups, and this change has been done done
"one for one".

Sorry again for any possible misleading,
Jarek P.
