Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbXJVWDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbXJVWDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXJVWDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:03:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33679 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbXJVWDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:03:14 -0400
Subject: Re: 2.6.23-mm1 - autofs broken
From: Dave Hansen <haveblue@us.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ian Kent <raven@themaw.net>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20071020105615.3e74c192@bree.surriel.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <20071020011310.30abc16b@bree.surriel.com>
	 <20071019223900.edd04f65.akpm@linux-foundation.org>
	 <20071020015404.437b6937@bree.surriel.com>
	 <20071020015445.0c0dcda6@bree.surriel.com>
	 <20071020105615.3e74c192@bree.surriel.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 15:03:10 -0700
Message-Id: <1193090590.17464.113.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-20 at 10:56 -0400, Rik van Riel wrote:
> I just tried it.  In the latest git tree, autofs still works.
> 
> The regression is in -mm only.

Andrew,

Rik tracked it down to an interaction with futexes from the pid
namespace code.  I believe r/o bind mounts are innocent for now.

-- Dave

