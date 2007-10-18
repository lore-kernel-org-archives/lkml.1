Return-Path: <linux-kernel-owner+w=401wt.eu-S1764936AbXJRWUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764936AbXJRWUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbXJRWUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:20:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:48874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508AbXJRWUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:20:39 -0400
Date: Fri, 19 Oct 2007 00:20:37 +0200
From: Andi Kleen <ak@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, vgoyal@in.ibm.com
Subject: Re: [patch 1/3] Add BSS to resource tree
Message-ID: <20071018222037.GC3459@bingen.suse.de>
References: <20071018111535.356215664@strauss.suse.de> <20071018111535.883533731@strauss.suse.de> <20071018142642.5b3f6ba4.akpm@linux-foundation.org> <20071018214836.GA3459@bingen.suse.de> <20071018215827.GB23708@uranus.ravnborg.org> <20071018220048.GB3459@bingen.suse.de> <20071018221813.GA23801@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018221813.GA23801@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Grepping for _text shows that there are plenty of different ways to declare
> that symbol extern - this does not look correct.

They really don't have a specific type and using the type that happens to be convenient 
to whatever calculation you want to do with it is useful.

-Andi
