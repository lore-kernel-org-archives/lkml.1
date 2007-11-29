Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbXK2G7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbXK2G7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXK2G65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:58:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16241 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbXK2G64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:58:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=MUo/n31t08q+VqnGXm0uEywUdNyVHaeaZAAxQTl/FgFwROYD2RoreW+CT/VKIO2Uv
	fH9uKn3fwedw41WEcfM7Q==
Message-ID: <532480950711282258w14fcd5adh497e19463bf51081@mail.gmail.com>
Date: Wed, 28 Nov 2007 22:58:48 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [patch 1/1] Writeback fix for concurrent large and small file writes
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, wfg@mail.ustc.edu.cn
In-Reply-To: <E1IxYuL-0001tu-8f@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071128192957.511EAB8310@localhost>
	 <E1IxYuL-0001tu-8f@faramir.fjphome.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you. Integrated the fixes in my patch.

On Nov 28, 2007 6:13 PM, Frans Pop <elendil@planet.nl> wrote:
> Two typos in comments.
>
> Cheers,
> FJP
>
> Michael Rubin wrote:
> > + * The flush tree organizes the dirtied_when keys with the rb_tree. Any
> > + * inodes with a duplicate dirtied_when value are link listed together.
> > This + * link list is sorted by the inode's i_flushed_when. When both the
> > + * dirited_when and the i_flushed_when are indentical the order in the
> > + * linked list determines the order we flush the inodes.
>
> s/dirited_when/dirtied_when/
>
> > + * Here is where we interate to find the next inode to process. The
> > + * strategy is to first look for any other inodes with the same
> > dirtied_when + * value. If we have already processed that node then we
> > need to find + * the next highest dirtied_when value in the tree.
>
> s/interate/iterate/
>
>
