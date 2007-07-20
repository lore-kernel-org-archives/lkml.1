Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXGTAU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXGTAU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXGTAUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:20:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286AbXGTAUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:20:17 -0400
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [1/2] 2.6.22-git: known regressions
References: <469F92A1.5070203@googlemail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Jul 2007 03:15:16 +0200
In-Reply-To: <469F92A1.5070203@googlemail.com>
Message-ID: <p738x9bx4d7.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski <michal.k.k.piotrowski@gmail.com> writes:

> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-git.

Here's a new one: 

appledisplay screen blanking driver seems to be broken
It doesn't blank anymore. I haven't done much debugging yet,
but the driver is loaded; just the screen stays on.
Not bisected currently.

> Subject         : Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')
> References      : http://lkml.org/lkml/2007/7/19/202
> Last known good : ?
> Submitter       : Gabriel C <nix.or.die@googlemail.com>
> Caused-By       : Jeremy Fitzhardinge <jeremy@xensource.com>
>                   commit c70df74376c1e29a04e07e23dd3f4c384d6166dd
> Handled-By      : ?
> Status          : unknown

Fix queued in my tree.


-Andi
