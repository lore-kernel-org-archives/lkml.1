Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXEKUwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXEKUwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966092AbXEKUwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:52:38 -0400
Received: from main.gmane.org ([80.91.229.2]:55220 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966053AbXEKUwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:52:36 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Ren=E9_Scharfe?= <rene.scharfe@lsrfire.ath.cx>
Subject: Re: [patch 3/7] add kstrndup
Date: Fri, 11 May 2007 22:52:09 +0200
Message-ID: <4644D779.30908@lsrfire.ath.cx>
References: <20070510235708.155502000@goop.org> <20070511000027.091968000@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Arnaldo Carvalho de Melo <acme@mandriva.com>,
       Al Viro <viro@ftp.linux.org.uk>, Panagiotis Issaris <takis@issaris.org>
X-Gmane-NNTP-Posting-Host: p508e63b7.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
In-Reply-To: <20070511000027.091968000@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	len = strlen(s);
> +	if (len > max)
> +		len = max;

You can avoid to run beyond max and save two lines by using strnlen:

	len = strnlen(s, max);

René

