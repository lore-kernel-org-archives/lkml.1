Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZGZXeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZGZXeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZGZXeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:34:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43836 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbZGZXeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:34:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YFhVQL/WXBW+o4OiL18X58f4rYLN2UeSe5qQk0j+cHDx1I+92ynlnTabJcTvQT3X3
	mMOpFiN3PIgQKWnheUiGA==
Date: Sun, 26 Jul 2009 16:33:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Matthew D. Reuther" <mreuther@joust.gpcc.itd.umich.edu>
cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@kroah.com>
Subject: Re: android lowmemorykiller breaks compile
In-Reply-To: <4A6CE261.mailHX41REN0Z@joust.gpcc.itd.umich.edu>
Message-ID: <alpine.DEB.2.00.0907261630420.17123@chino.kir.corp.google.com>
References: <4A6CE261.mailHX41REN0Z@joust.gpcc.itd.umich.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009, Matthew D. Reuther wrote:

> I don't actually use Android, but I compile it just for giggles. With every one of the 2.6.31-rc releases, my compile breaks when it hits lowmemorykiller:
> 
> drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
> drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'
> make[3]: *** [drivers/staging/android/lowmemorykiller.o] Error 1
> make[2]: *** [drivers/staging/android] Error 2
> 
> Maybe this should not be selectable for x86? Can't tell.
> 

It's had a fix pending in Greg KH's staging tree for a couple months, 
we're just waiting for it to be pushed to Linus.  Greg indicated he will 
send it in his next staging pull.

Thanks.
