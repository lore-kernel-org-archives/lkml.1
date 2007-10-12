Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXJLC0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXJLC0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbXJLC0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:26:36 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:39767 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbXJLC0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:26:35 -0400
Date: Thu, 11 Oct 2007 22:26:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] __do_softirq() loop cleanup
Message-ID: <20071012022633.GA10949@goodmis.org>
References: <20071010121619.GA32677@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010121619.GA32677@saeurebad.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 02:16:19PM +0200, Johannes Weiner wrote:
> Hi,
> 
> This changes __do_softirq() to use a C looping construct instead of
> simulating one by means of goto.
> 
> Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>
> 

I've read over the logic three times and it seems to keep with the
original design.  So unless I missed something ...

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

