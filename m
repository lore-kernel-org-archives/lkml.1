Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbZIGIhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbZIGIhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZIGIhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:37:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:57422 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZIGIhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:37:16 -0400
Message-ID: <4AA4C628.3070300@kernel.org>
Date: Mon, 07 Sep 2009 17:36:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the percpu tree with Linus' tree
References: <20090907182229.734c31d2.sfr@canb.auug.org.au>
In-Reply-To: <20090907182229.734c31d2.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 07 Sep 2009 08:36:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the percpu tree got a conflict in mm/percpu.c
> between commit 04a13c7c632e1fe04a5f6e6c83565d2559e37598 ("percpu: don't
> assume existence of cpu0") from Linus' tree and commit pcpu_chunk_page_occupied ("percpu: drop pcpu_chunk->page[]") from the percpu tree.
> 
> I *think* the changes in the percpu tree supercede those in Linus' tree,
> so I have used those.

Yes, the changes in Linus's tree are backported from devel branch but
the devel already has moved on and dropped one of the changes.  I'll
merge Linus's tree into percpu devel branch.

Thanks.

-- 
tejun
