Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbXIULNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbXIULNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXIULNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:13:14 -0400
Received: from mx10.go2.pl ([193.17.41.74]:39868 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756180AbXIULNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:13:13 -0400
Date: Fri, 21 Sep 2007 13:15:20 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070921111520.GC1758@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net> <46F270DA.5030101@bull.net> <20070921084453.GA1758@ff.dom.local> <46F398C3.3000804@bull.net> <20070921110347.GB1758@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921110347.GB1758@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 01:03:47PM +0200, Jarek Poplawski wrote:
...
> any of them does ipc_rcu_getref() a bit later and sees old (cached)

Should be:
"any of them does ipc_rcu_putref() a bit later and sees old (cached)"

Sorry,
Jarek P.
