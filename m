Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZBOIIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZBOIIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 03:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZBOIIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 03:08:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:6607 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZBOIIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 03:08:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D7Mttjzvsi3ROPMjVK9bLX+VV4U+EUnNYiG0jZiLXaGWnG0PovjDBIhY0Ect3de2dU
         KKPbvPvCxH15XXd/bfZYMvx7KGost4RGmRL3/r635yZF34/6qBCA2+XJylD+RRTfzoIM
         F8J9XGFmmibJtpW+KVX10xhP7LMQuGrrwHRSY=
Date: Sun, 15 Feb 2009 11:08:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hannes Eder <hannes@hanneseder.net>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/43] drivers/net/ppp*.c: fix sparse warnings: fix
	signedness
Message-ID: <20090215080802.GA7406@localhost>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net> <20090214211346.23489.96321.stgit@vmbox.hanneseder.net> <20090214212948.GE7648@localhost> <20090214213848.GF7648@localhost> <154e089b0902141357x3af8b2adk223749ce11e976ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0902141357x3af8b2adk223749ce11e976ef@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hannes Eder - Sat, Feb 14, 2009 at 10:57:24PM +0100]
...
| > Btw I think the same fix could be applied on
| > drivers/net/tun.c (if you have time for :)
| 
| This was fixed by this commit:
| commit 745417e20684e4951afcabfe74583a3884e54980
| Author: Gerrit Renker <gerrit@erg.abdn.ac.uk>
| Date:   Sun Jan 4 17:14:46 2009 -0800
| 
| which is in the linux-next tree.

Ah, good to know, thanks!

| 
| BTW, how can I check from which tree this commit came into the linux-next tree?
| 
| -Hannes
| 

Not sure if it possible to find. if the commit was pulled without
additional comments -- the only thing could be obtained -- is commit
id itself. You better to ask someone who knows git well, not me :)

	- Cyrill -
