Return-Path: <linux-kernel-owner+w=401wt.eu-S935227AbYBUXby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935227AbYBUXby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYBUXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:31:45 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52088 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbYBUXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:31:44 -0500
Date: Fri, 22 Feb 2008 00:31:42 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <greg@kroah.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Merging of completely unreviewed drivers
In-Reply-To: <20080221224315.GA27640@kroah.com>
Message-ID: <Pine.LNX.4.64.0802220025240.26109@fbirervta.pbzchgretzou.qr>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
 <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi>
 <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi>
 <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
 <20080221223303.GD1846@martell.zuzino.mipt.ru> <20080221224315.GA27640@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 21 2008 14:43, Greg KH wrote:
>On Fri, Feb 22, 2008 at 01:33:03AM +0300, Alexey Dobriyan wrote:
>> On Thu, Feb 21, 2008 at 01:14:55PM -0800, Linus Torvalds wrote:
>> > Quite frankly, I've several times been *this* close (holds up fingers so 
>> > you can't even see between them) to just remove checkpatch entirely.
>> 
>> Agrh! What stopped you?!
>> 
>> > I'm personally of the opinion that a lot of checkpatch "fixes" are 
>> > anything but. That mainly concerns fixing overlong lines (where the 
>> > "fixed" version is usually worse than the original), but it's been true 
>> > for some other warnings too.
>> 
>> Speaking of driver, could authors please comment all those barrier()
>> calls and remove trailing "return;" at the end of void functions.
>
>Why don't you make a patch to checkpatch.pl for those types of things?
>:)

checkpatch would never allow a patch to patch checkpatch.
