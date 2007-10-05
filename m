Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbXJELfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbXJELfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXJELfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:35:07 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:45804 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751940AbXJELfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:35:05 -0400
Message-ID: <391584104.28633@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 5 Oct 2007 19:35:00 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: BUG on unloading the fuse module
Message-ID: <20071005113500.GA10052@mail.ustc.edu.cn>
References: <391574553.18064@ustc.edu.cn> <E1Idjd8-0002rY-00@dorka.pomaz.szeredi.hu> <391581094.26735@ustc.edu.cn> <E1Idkor-0002v6-00@dorka.pomaz.szeredi.hu> <391582087.27602@ustc.edu.cn> <E1IdlQc-0002wt-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IdlQc-0002wt-00@dorka.pomaz.szeredi.hu>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 01:33:10PM +0200, Miklos Szeredi wrote:
> > > > > > In 2.6.23-rc8-mm2, the fuse module always bugs on unloading.
> > > > > 
> > > > > It's fixed in Greg's patch queue.
> > > > > 
> > > > > This patch against -mm will also fix it.
> > > > 
> > > > Oh no, it panics:
> > > 
> > > How about this one?
> > 
> > Yes, it did the trick.
> 
> Thanks.
> 
> It seems, some kobject ->release() function is freeing kobj->k_name,
> so we need to free it, and set it to NULL _before_ calling
> ->release().

Agreed.

> Greg, can you please fix that in your queue?

Acked-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

