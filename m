Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKRN3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKRN3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYKRN3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:29:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYKRN3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:29:20 -0500
Date: Tue, 18 Nov 2008 08:29:19 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20081118132919.GB18198@infradead.org>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com> <9395c0a4110469d19100084664900789c34ebd42.1226547084.git.zohar@linux.vnet.ibm.com> <20081117160515.GA25459@infradead.org> <1226948980.2927.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226948980.2927.33.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 02:09:40PM -0500, Mimi Zohar wrote:
> Ok. So, instead of integrity_nameidata_check(nd, flags), call it
> integrity_path_check(path, flags). 

Yeah.

> Perhaps I'm looking at the wrong vfs tree, but I don't see the changes.
> Where is fsdevel? 

linux-fsdevel@vger.  But the patch actually went to lkml,
"[PATCH] pass a struct path * to may_open".  Note that the plan is to
reduce availability of strut nameidata to a minimum outside of the core
path lookup functionality - so relying on it is not a good idea.

