Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYJDUT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYJDUT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYJDUTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:19:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:58922 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYJDUTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:19:17 -0400
Date: Sat, 4 Oct 2008 13:19:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       alan-jenkins@tuffmail.co.uk
Subject: Re: [PATCH -tip] Fastboot: fix initcalls disposition in
 bootgraph.pl
Message-ID: <20081004131901.66720416@infradead.org>
In-Reply-To: <48E7C594.4030400@gmail.com>
References: <48E7C594.4030400@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Oct 2008 21:35:48 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> When bootgraph.pl parses a file, it gives one row
> for each initcall's pid. But only few of them will
> be displayed => the longest.
> This patch corrects it by giving only a rows for pids
> which have initcalls that will be displayed.
> You can see the result in attachment, before and after the patch.
> 
> Ingo, could you please revert the commit
> b4bc656397071b18c99e85d9181f076e44de8a99 which was a false solution
> to solve this problem. Thanks.


I wonder about this.. there's only supposed to be 2....
your graph is quite different.
