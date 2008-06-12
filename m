Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYFLBfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYFLBfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYFLBfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:35:14 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35321 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754377AbYFLBfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:35:13 -0400
Date: Wed, 11 Jun 2008 21:35:09 -0400
From: Theodore Tso <tytso@mit.edu>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-ext4@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Performance of ext4
Message-ID: <20080612013509.GS8397@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Holger Kiehl <Holger.Kiehl@dwd.de>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de> <20080611135443.GK8397@mit.edu> <Pine.LNX.4.64.0806111959270.3720@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806111959270.3720@diagnostix.dwd.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 08:21:50PM +0000, Holger Kiehl wrote:
> I think you mean 'small files'? 

Yes, sorry, I meant "small files".

> The test where done with a plain 2.6.25.4,
> does that already have barriers enabled? While I did some test I hit this 
> bug:

No, 2.6.25.4 does not have barriers enabled.  It's in the latest
post-2.6.25.5 git repository (which also has the fix so that
barriers=1 doesn't cause an OOPS if you are doing the test on a LVM
device which doesn't support barriers).  Sorry, I wasnt sure if you
were using any of the ext4 patches, and I didn't know whether you were
testing on a raw device or an LVM device.

							 - Ted
