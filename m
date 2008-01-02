Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbYABUhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbYABUhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYABUhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:37:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55596 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYABUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:37:39 -0500
Date: Wed, 2 Jan 2008 20:37:35 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: do not add new typedefs - is that for real?
Message-ID: <20080102203735.GB15099@infradead.org>
References: <477A6732.4010609@panasas.com> <20080102100852.GA19859@infradead.org> <477B8113.6080602@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477B8113.6080602@panasas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 02:18:27PM +0200, Boaz Harrosh wrote:
> > But yes, this is one of the rare cases where a typedef makes sense,
> > but ???'d call it osd_off_t or something like that.
> > 
> 
> You mean osd_cdb_offset_t. I thought of dropping that _t, I hate it,
> just a personal preference.

No, I mean osd_off_t :)  off vs offset is purely cosmetic, but in Linux
we have a strong preference for short typenames.  Just look how ugly
the prototype and struct defintion in your original posting look :)

Also I thing the _cdb is superflous because there is no other offset
type in the OSD spec.

