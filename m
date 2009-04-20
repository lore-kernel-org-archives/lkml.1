Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZDTUld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZDTUld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZDTUlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:41:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809AbZDTUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:41:23 -0400
Date: Mon, 20 Apr 2009 13:31:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: Microblaze fixes for revision
Message-Id: <20090420133125.3615a80d.akpm@linux-foundation.org>
In-Reply-To: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 11:56:27 +0200
monstr@monstr.eu wrote:

> here are some patches which fixed some minor things.

How are microblaze patches getting into Linus's tree?

An appropriate route would be for you to ask him to pull the git tree. 
I could send them (as I do with alpha, uml and maybe others), but
that's more a last-resort way of maintaining an architecture.

The microblaze git tree should be included in linux-next.  Please
prepare a branch and send the info over to Stephen Rothwell
<sfr@canb.auug.org.au> and linux-next@vger.kernel.org to get that all
set up.

For these particular patches: officially, 2.6.30-rcN is in bugfix-only
mode.  But as microblaze is newly-added in 2.6.30 I think it's OK to
put non-bugfixes into 2.6.30 as well - we might as well get the
architecture as up-to-date as possible for the 2.6.30 release.

