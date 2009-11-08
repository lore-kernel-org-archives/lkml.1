Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZKHNn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZKHNn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZKHNn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:43:57 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:41434 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbZKHNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:43:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i2Cg/FM+PeM9LyhAcbLoknMXtrLR1QWnNj5fhdBrb06w9Rd5wzzR0rJmo6xlx1xXaC
         KXzu8rajTm6qOYxW+xF4k070Ni96lSgg+MFU9L6Byrr2cPhLuEJuyxqUynFDWDGl6kSl
         wqvwx1Be2nBkbiD6wr5LRWAqkOxTRrikGospk=
Date: Sun, 8 Nov 2009 16:43:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build warning
Message-ID: <20091108134359.GF5300@lenovo>
References: <20091028181443.50a09dbb.sfr@canb.auug.org.au> <20091028073145.GD6353@elte.hu> <20091028184126.b5f52d1b.sfr@canb.auug.org.au> <20091028184851.504752ef.sfr@canb.auug.org.au> <20091028075012.GD19402@elte.hu> <20091108131645.GD5300@lenovo> <20091108133247.GA14807@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108133247.GA14807@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Nov 08, 2009 at 02:32:47PM +0100]
...
| 
| > +
| > +#ifdef CONFIG_X86_32
| >  	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
| > +#else
| > +	.apicid_to_cpu_present		= NULL,
| > +#endif
| 
| would be better to unify this instead ...
| 
| 	Ingo
| 

OK, wait a bit.

	-- Cyrill
