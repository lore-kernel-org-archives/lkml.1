Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYKTRpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYKTRpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYKTRpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:45:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYKTRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:45:08 -0500
Date: Thu, 20 Nov 2008 12:45:06 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20081120174506.GA20972@infradead.org>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com> <ece5bb6863d9b42016860f3ef78656e4a228ad95.1227137423.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ece5bb6863d9b42016860f3ef78656e4a228ad95.1227137423.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, the API looks sane to me.  But one big question:  any reason you
don't just directly call into your implementation instead of all these
odd hooks?  This seems to be a lot of overhead just for making the code
less readable..
