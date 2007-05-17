Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbXEQWpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbXEQWpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEQWpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:45:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:58062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbXEQWpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:45:24 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Date: Thu, 17 May 2007 18:42:43 -0400
User-Agent: KMail/1.9.5
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171508.40202.lenb@kernel.org> <20070517215321.GC7336@elf.ucw.cz>
In-Reply-To: <20070517215321.GC7336@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171842.44134.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Something similar happened to me on XE3, yes.
> 
> (Actual values were different; BIOS specified critical temperature at
> cca 95C, but hw killed the power at cca 83C. Setting critical trip
> point at 80C made the problem go away.)

Great, please file a bug and include the acpidump from the XE3
and we'll fix it, rather than supporting a bogus (manual) workaround for it.

Of course if your system is running at 80*C and the hardware shuts
off at 83*C, you may have a broken fan, or one clogged with dust...

-Len

