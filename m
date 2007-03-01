Return-Path: <linux-kernel-owner+w=401wt.eu-S1161157AbXCAXvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157AbXCAXvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161187AbXCAXvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:51:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49618 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161157AbXCAXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:51:06 -0500
Date: Thu, 1 Mar 2007 23:51:01 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070301235101.GA2519@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <45E761CB.2020904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E761CB.2020904@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 05:29:15PM -0600, Eric Sandeen wrote:
> Amit K. Arora wrote:
> 
> Might want more error checking in there, something like (rough cut)...
> (or is some of this glibc's job?)

Yeah, we need to have this checks.  We can't rely on userspace not
passing arguments that might corrupt your filesystem or let you
escalate privilegues.

> which would keep things in line with posix_fallocate's specified errors, 
> too?

Yes, very good idea.

