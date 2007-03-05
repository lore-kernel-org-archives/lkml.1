Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbXCEQOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbXCEQOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXCEQOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:14:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbXCEQOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:14:51 -0500
Message-ID: <45EC41E7.4030109@redhat.com>
Date: Mon, 05 Mar 2007 11:14:31 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: [PATCH] x86_64: shut up vm86(2)
References: <20070228214046.GA5539@martell.zuzino.mipt.ru> <20070305142243.GB22829@bingen.suse.de>
In-Reply-To: <20070305142243.GB22829@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Mar 01, 2007 at 12:40:46AM +0300, Alexey Dobriyan wrote:
>> From originally rate-limited printk, to just printk, to current version.
>> Everybody had enough time to learn about vm86(2) absense.
> 
> I don't think that's true. I prefer to keep the message.
> 

How about limiting the warning to some fixed number of times?
It really is trivial to get around the limiting that's in
there now...
