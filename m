Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXEJMrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXEJMrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761347AbXEJMqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:46:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:39068 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761220AbXEJMqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:46:53 -0400
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] memory hotremove patch take 2 [01/10] (counter of removable page)
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
	<20070509120132.B906.Y-GOTO@jp.fujitsu.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 May 2007 15:44:08 +0200
In-Reply-To: <20070509120132.B906.Y-GOTO@jp.fujitsu.com>
Message-ID: <p73bqgsg5ef.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto <y-goto@jp.fujitsu.com> writes:


(not a full review, just something I noticed)
> @@ -352,6 +352,8 @@ struct sysinfo {
>  	unsigned short pad;		/* explicit padding for m68k */
>  	unsigned long totalhigh;	/* Total high memory size */
>  	unsigned long freehigh;		/* Available high memory size */
> +	unsigned long movable;		/* pages used only for data */
> +	unsigned long free_movable;	/* Avaiable pages in movable */

You can't just change that structure, it is exported to user space.

-Andi
