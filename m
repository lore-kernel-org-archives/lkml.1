Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbYBLJq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbYBLJq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbYBLJqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:46:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755972AbYBLJqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:46:34 -0500
Date: Tue, 12 Feb 2008 01:44:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, matthltc@us.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 7/8] Do not recompute msgmni anymore if explicitely set
 by user
Message-Id: <20080212014444.8bc3791b.akpm@linux-foundation.org>
In-Reply-To: <47B167AF.6010008@bull.net>
References: <20080211141646.948191000@bull.net>
	<20080211141816.094061000@bull.net>
	<20080211122408.5008902f.akpm@linux-foundation.org>
	<47B167AF.6010008@bull.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 10:32:31 +0100 Nadia Derbey <Nadia.Derbey@bull.net> wrote:

> it builds fine, modulo some changes in ipv4 and ipv6 (see attached patch 
> - didn't find it in the hot fixes).

OK, thanks for checking.  Did you confirm that we don't have unneeded code
in vmlinux when CONFIG_PROCFS=n?  I guess before-and-after comparison of
the size(1) output would tell us.

Those networking build problems appear to have already been fixed.

In future, please quote the compiler error output in the changelog when
sending build fixes or warning fixes, thanks.

