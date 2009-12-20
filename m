Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZLTVOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZLTVOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZLTVOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:14:39 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:33220 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbZLTVOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:14:38 -0500
Date: Mon, 21 Dec 2009 08:14:36 +1100
From: Simon Horman <horms@verge.net.au>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: David Airlie <airlied@linux.ie>, Jesse Barnes <jesse.barnes@intel.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Silancing a false positive: "may be used uninitialized"
Message-ID: <20091220211433.GA6025@verge.net.au>
References: <200912200903.28002.mitov@issp.bas.bg>
 <20091220095644.GA17838@verge.net.au>
 <200912201243.20111.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912201243.20111.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 12:43:19PM +0200, Marin Mitov wrote:
> On Sunday 20 December 2009 11:56:44 am Simon Horman wrote:
> > On Sun, Dec 20, 2009 at 09:03:27AM +0200, Marin Mitov wrote:
> > > Hello all,
> > > 
> > > Silancing a false positive:
> > > warning: 'width' may be used uninitialized in this function
> > > drivers/gpu/drm/drm_edid.c
> > 
> > Is it guaranteed that the switch will always see a value covered by the
> > four cases it has? 
> 
> Yes it is. The value is masked (& 0xc0) so all the possible values are
> (0x00, 0x40, 0x80, 0xc0) covered by the switch. That's why it is false positive.

Of course, silly me.

