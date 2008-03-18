Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYCRDl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYCRDl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 23:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYCRDlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 23:41:49 -0400
Received: from sandeen.net ([209.173.210.139]:16585 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYCRDls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 23:41:48 -0400
Message-ID: <47DF39FB.7060306@sandeen.net>
Date: Mon, 17 Mar 2008 22:41:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: hch@infradead.org, andi@firstfloor.org, byron.bbradley@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: XFS Fails Quality Assurance Tests on ARM
References: <p73ps12vxrl.fsf@bingen.suse.de>	<4726C577.9000209@sandeen.net>	<20071030175418.GA17768@infradead.org> <20071030.143834.127458535.davem@davemloft.net>
In-Reply-To: <20071030.143834.127458535.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Tue, 30 Oct 2007 17:54:18 +0000
> 
>> On Tue, Oct 30, 2007 at 12:47:35AM -0500, Eric Sandeen wrote:
>>> There was a patch floating around to "fix" it but it's not on-disk
>>> compatible w/ x86 & friends, it just makes things consistent for arm.  I
>>> think packing some of these structures would take care of it, but this
>>> problem could use some attention & testing I think, it's been floating
>>> around a long time.
>> Do you have a pointer to that patch?  Once the unaliged fields are
>> identified simply using get_unaligned on them should fix this issue.
> 
> True, but there is the tertiary issue that the packing done by these
> platforms might mean that the on-disk format is different on different
> platforms which the XFS folks likely want to avoid if possible.

Right.

FWIW, this patch should fix up at least the most egregious problems, and
in fact I think most likely resolves the whole issue with the old arm
ABI, though for some reason, qemu issues keep me from getting a whole
xfstests QA run to complete....

http://oss.sgi.com/archives/xfs/2008-03/msg00151.html

-Eric

