Return-Path: <linux-kernel-owner+w=401wt.eu-S1764668AbXJFB1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764668AbXJFB1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 21:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbXJFB1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 21:27:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:57604 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXJFB1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 21:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PVjf+GhUsTCCwKxJld5WZz8Jrb6v0XGVsbIzMK+Fvn7hhaGKOrRP0suWu1x+RddIOSRESH45n9bBL4ACL/dS3NspKc9Vqj3yxGDIojNqjSMTjIYmi/jupQ5wDpqknQAdwUUUKXSU+9RfGbbDA7/3v6Co3z8xt3zWSvhpjVqEVdg=
Date: Sat, 6 Oct 2007 09:21:25 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org
Subject: Re: [Patch]Documentation/vm/slabinfo.c: clean up this code
Message-ID: <20071006012125.GA2436@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071005124614.GD12498@hacking> <Pine.LNX.4.64.0710051216250.17345@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710051216250.17345@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 12:17:41PM -0700, Christoph Lameter wrote:
>On Fri, 5 Oct 2007, WANG Cong wrote:
>
>> 
>> This patch does the following cleanups for Documentation/vm/slabinfo.c:
>> 
>> 	- Fix two memory leaks;
>
>For user space code? Memory will be released as soon as the program 
>terminates.

Yes, it's of course in user space. But there really exists memory leaks,
since strdup(3) uses malloc(3) to allocate memory for new string, we
should use free(3) to free the memory, or this memory will be lost.

Regards. ;)


WANG Cong

