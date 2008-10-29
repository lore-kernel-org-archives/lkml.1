Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYJ2NLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYJ2NLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYJ2NK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:10:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:13458 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYJ2NKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ewx3UG12fwE8rdSr0Cc4XHKdm6Y6KkljpHrQ6QV3gQ0kDMhXIpuoQbxeNX/lABOcnj
         icH6DODoC5W8fHdzcrNeuBEF29W560gsPAvARYvL7xJAIJjMozBOhKfUTW53OtPZFpiQ
         u1lfXr/IH47Alu7s+NOlgQgC4c3cqWjkGGxl0=
Date: Wed, 29 Oct 2008 16:14:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org, viro@zeniv.linux.org.uk,
       acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] headers: move release_kernel_lock(),
	reacquire_kernel_lock() to sched.c
Message-ID: <20081029131402.GA2642@x200.localdomain>
References: <20081029044351.GA2304@x200.localdomain> <20081029044447.GB2304@x200.localdomain> <20081029061827.GA7936@elte.hu> <20081029100437.GA30492@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029100437.GA30492@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 06:04:37AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 29, 2008 at 07:18:27AM +0100, Ingo Molnar wrote:
> > please dont move #ifdefs and interfaces into a .c file - if then move 
> > it into another header file.
> 
> Sorry, but that makes no sense at all.  This stuff is implementation
> private to sched.c, and adding some header for it is just braindead.

Well, yes, that was the logic behind move -- keep it private to scheduler.
