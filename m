Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751633AbYLQTHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbYLQTHU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYLQTHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:07:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYLQTHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:07:03 -0500
Date: Wed, 17 Dec 2008 14:07:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: initramfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Dave Jones <davej@redhat.com>, cjwatson@ubuntu.com,
        Hannes Reinecke <hare@suse.de>
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
Message-ID: <20081217190700.GA15377@infradead.org>
References: <1229540094.28858.150.camel@aglarond.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229540094.28858.150.camel@aglarond.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 01:54:54PM -0500, Jeremy Katz wrote:
> As davej started talking about a few months ago at Kernel Summit and
> LPC, there's a lot of duplication between distros on the tools used to
> generate the initramfs as well as the contents and how the initramfs
> works.  Ultimately, there's little reason for this not to be something
> that is shared and worked on by everyone.  Added to this is the fact
> that everyone's infrastructures for this have grown up over a long-ish
> period of time without significant amounts of reworking for the way that
> the kernel and early boot works these days.
> 
> Therefore I've started on a new project, dracut, to try to be a new
> initramfs tool that can be used across various distributions.  From the
> README...

It looks like Hannes has also been working on a new, modular initramfs
for a while:

	http://git.kernel.org/?p=linux/kernel/git/hare/mkinitrd.git;a=summary

I hope you guys can get together and agree on one implementation..
