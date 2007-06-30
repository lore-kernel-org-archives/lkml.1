Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbXF3JPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbXF3JPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXF3JPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:15:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60623 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbXF3JPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:15:32 -0400
Date: Sat, 30 Jun 2007 10:15:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFD 0/4] AppArmor - Don't pass NULL nameidata to vfs_create/lookup/permission IOPs
Message-ID: <20070630091530.GC21784@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070626231510.883881222@suse.de> <1182901575.12836.54.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182901575.12836.54.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 07:46:15PM -0400, Trond Myklebust wrote:
> I don't object to the concept per se, but could you please give it a
> more descriptive name please? "struct vfs_intent" would be a lot more
> accurate than "nameidata2".

Agreed, but I prefer lookup_intent - intent by itself is a word with
just to wide useage and vfs doesn't make it much clearer..

