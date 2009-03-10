Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZCJQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZCJQXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZCJQXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:23:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44179 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZCJQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:23:04 -0400
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090310105702.43eb1402@thinkcentre.lan>
References: <20090305163857.0C18F3FD@kernel>
	 <20090310105702.43eb1402@thinkcentre.lan>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 09:22:45 -0700
Message-Id: <1236702165.10626.167.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 10:57 -0500, Nathan Lynch wrote:
> From a0fb96aa41c4d360559013cfd7f32f07f449c1c4 Mon Sep 17 00:00:00 2001
> From: Nathan Lynch <ntl@pobox.com>
> Date: Mon, 9 Mar 2009 22:23:02 -0500
> Subject: [PATCH] checkpoint: make files_deny_checkpointing print task
> name and pid
> 
> This lets the developer know *which* task performed an action that
> prevents checkpoint.

Can you think of any case where we wouldn't be calling
foo_deny_checkpoint() for a task other than current?  Should we just use
current in the function directly instead of passing it in?

-- Dave

