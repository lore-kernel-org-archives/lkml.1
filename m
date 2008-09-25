Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYIYCvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYIYCvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYIYCvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:51:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:7277 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYIYCvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ygp8k9H4S8FCowaKutxcWE/CT6lWSYdLoLrrBLm47AHMllydYPqEhTeRvmywQwHQBc
         wi5wGNzfS1Brx+q5l4zi7RnQVG3VYzVvkv7xLqWzX5qvcLa10miVGIolxzeqowjOqyUA
         Bh6OrutgQkyNZWDSTBDGgZm+1D63zQM5PG7sM=
Date: Thu, 25 Sep 2008 10:51:02 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message
	when running as VMware guest
Message-ID: <20080925025102.GI21049@yantp.cn.ibm.com>
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com> <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com> <20080924141616.GV24392@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924141616.GV24392@amd.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 04:16:16PM +0200, Joerg Roedel wrote:
> A lot of code if #ifdef'ed to vmware. Can you hide this into a header
> file? This way its not very clean code I think.

Hum.. OK, I'm thinking about this.

> Can we move the WARN after the DMI scanning for all cases? This will
> save this #ifdef and is a cleaner approach imho.

Sounds good. Thanks!


-- 
Li, Yan
