Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXIXXFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXIXXFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760451AbXIXXFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:05:40 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38168 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760570AbXIXXFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:05:39 -0400
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20070924152532.305ec951.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195320.38C8E20D@kernel>
	 <20070923231713.f81ee0db.akpm@linux-foundation.org>
	 <1190671602.26982.261.camel@localhost>
	 <20070924152532.305ec951.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 16:05:37 -0700
Message-Id: <1190675137.26982.266.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 15:25 -0700, Andrew Morton wrote:
> hm.  I saw that warning on my 2-way.  It has CONFIG_NR_CPUS=8 so perhaps
> the kernel has decided that this machine can possibly have eight CPUs.
> 
> It's an old super-micro board, doesn't have ACPI.

Well, it's looking like we only set cpu_possible_map from data we find
in the MP table, which makes sense.  The only question is how your
system gets more than ~8 possible cpus.  Do you have the .config handy?

-- Dave

