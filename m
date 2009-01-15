Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZAOCN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZAOCN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZAOCNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:13:48 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:30313 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZAOCNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:13:47 -0500
Subject: Re: Warning and BUG with btrfs and corrupted image
From: Chris Mason <chris.mason@oracle.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <20090113144307.GF16333@alice>
References: <20090113142147.GE16333@alice>
	 <1231857643.29164.28.camel@think.oraclecorp.com>
	 <20090113144307.GF16333@alice>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 21:13:37 -0500
Message-Id: <1231985617.8269.68.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.496E9BD5.01EC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 15:43 +0100, Eric Sesterhenn wrote:
> * Chris Mason (chris.mason@oracle.com) wrote:
> > On Tue, 2009-01-13 at 15:21 +0100, Eric Sesterhenn wrote:
> > > Hi,
> > > 
> > > when mounting an intentionally corrupted btrfs filesystem i get the
> > > following warning and bug message. The image can be found here
> > > www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2
> > 
> > Thanks for looking at things
> > 
> > Aside from catching checksumming errors, we're not quite ready for
> > fuzzer style attacks.  The code will be hardened for this but it isn't
> > yet.
> 
> Does this mean i should stop trying to break it for now or are you interested
> in further reports?

For now, you'll be able to break it at will ;)  We'll send out a please
send us corrupt notice release announcement when we've hardened things.

-chris


