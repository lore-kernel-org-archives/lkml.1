Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYLCQ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYLCQ4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYLCQ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:56:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43382 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYLCQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:56:07 -0500
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081203130301.GA9681@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
	 <1228260925.2971.240.camel@nimitz>  <20081203130301.GA9681@infradead.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 08:55:54 -0800
Message-Id: <1228323355.2971.259.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 08:03 -0500, Christoph Hellwig wrote:
> On Tue, Dec 02, 2008 at 03:35:25PM -0800, Dave Hansen wrote:
> > If you're looking for another way to split your patch out, you could
> > just stick use inode->integrity for the first patch, then introduce your
> > radix-tree in a subsequent patch.  It would be functionally fine, and
> > more clearly separate out the ideas.
> 
> This was done earlier and is a really bad thing for review.  Just as the
> breakout happening in this round.

If Christoph and I tell you conflicting things, it goes without saying
to listen to Christoph.  :)

-- Dave

