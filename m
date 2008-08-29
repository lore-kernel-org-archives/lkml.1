Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbYH2OGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbYH2OGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbYH2OGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:06:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50067 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbYH2OGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:06:23 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
From: Andi Kleen <andi@firstfloor.org>
References: <20080829140224.GC1968@parisc-linux.org>
Date: Fri, 29 Aug 2008 16:06:15 +0200
In-Reply-To: <20080829140224.GC1968@parisc-linux.org> (Matthew Wilcox's message of "Fri, 29 Aug 2008 08:02:24 -0600")
Message-ID: <87ej47q5k8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> I'm in the middle of implementing a userspace client for usbip and I
> strongly feel that the protocol needs to be changed before it is merged.
>
>  - I'm unconvinced that TCP is the correct protocol to be running this over.
>    I understand the reluctance to use UDP, but the protocol is fundamentally
>    packet-based.  If TCP is used, the delimitation of packets within the
>    stream needs to be much more robust. 

If you want reliable transport with record boundaries an alternative
would be also SCTP. Main drawback is that firewalls often don't support it
though (but presumably that wouldn't be a big issue for this)

-Andi
-- 
ak@linux.intel.com
