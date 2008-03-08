Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYCHOyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYCHOyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 09:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYCHOxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 09:53:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYCHOxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 09:53:52 -0500
Date: Sat, 8 Mar 2008 09:53:51 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com
Subject: Re: [RFC, PATCH 4/6] jbd: refactor nested journal log recovery
	loop into separate functions
Message-ID: <20080308145351.GB18522@infradead.org>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg@dghda.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 01:59:12AM +0000, Duane Griffin wrote:
> +static int replay_data_block(
> +	journal_t *journal, struct buffer_head *obh, char *data,
> +	int flags, unsigned long blocknr)

quite odd formatting, this should be more like:

static int replay_data_block(journal_t *journal, struct buffer_head *obh,
		char *data, int flags, unsigned long blocknr)

(same for the other new helpers)

