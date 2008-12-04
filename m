Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYLDNSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYLDNSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYLDNR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:17:57 -0500
Received: from vps1.tull.net ([66.180.172.116]:38952 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751944AbYLDNR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:17:57 -0500
Date: Fri, 5 Dec 2008 00:17:52 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: printk: fix indentation of new_text_line	declaration
Message-ID: <20081204131752.GA16905@mail.local.tull.net>
References: <alpine.LNX.1.10.0812041242260.5809@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0812041242260.5809@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 12:44:34PM +0100, Jiri Kosina wrote:
> I have just come across bogus indentation of new_text_line declaration. I 
> have applied the patch below to trivial tree. If the indentation had some 
> specific non-obvious purpose and was done intentionally this way, please 
> let me know :)

That's cool. Ingo tweaked my patch and moved the static declaration
outside the function and mistakenly left the indent in place.

I'm actually not too happy about new_text_line being a static; I may
well submit a patch to fix that. But in the meantime, fixing the indent
is fine.

> From: Jiri Kosina <jkosina@suse.cz>
> Subject: trivial: printk: fix indentation of new_text_line declaration
> 
> Remove bogus indentation of new_text_line declaration introduced in
> commit ac60ad741.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Nick Andrew <nick@nick-andrew.net>

Nick.
