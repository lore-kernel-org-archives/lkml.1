Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYIBTck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYIBTck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYIBTc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:32:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:53240 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYIBTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:32:28 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: David Woodhouse <dwmw2@infradead.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <20080902191333.GL3086@webber.adilger.int>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron>
	 <20080902170954.GE3086@webber.adilger.int>
	 <1220376569.2982.225.camel@pmac.infradead.org>
	 <20080902191333.GL3086@webber.adilger.int>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 20:32:23 +0100
Message-Id: <1220383943.2982.240.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 13:13 -0600, Andreas Dilger wrote:
> My bad - I had looked back in email archives about this issue and got
> the export operation solution stuck in my head...
> 
> Yes, using f_fsid is the right way to do this, assuming NFSD plays
> along.

It does now, if it can't find a UUID by other means.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



