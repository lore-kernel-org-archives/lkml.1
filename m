Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYK1LS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYK1LS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYK1LSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:18:17 -0500
Received: from mail2.shareable.org ([80.68.89.115]:40430 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYK1LSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:18:16 -0500
Date: Fri, 28 Nov 2008 11:18:09 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v4] relatime: Make relatime smarter
Message-ID: <20081128111809.GH6138@shareable.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127170615.GB14991@infradead.org> <20081127175813.GA24354@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127175813.GA24354@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> The time between atime updates can be configured at boot
> with the relatime_interval kernel argument, or at runtime through a sysctl.

Shouldn't it be a per-mount value, with defaults coming from the sysctl?

-- Jamie
