Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZEOQgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZEOQgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763532AbZEOQg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:36:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57315 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762468AbZEOQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:36:26 -0400
Date: Fri, 15 May 2009 10:36:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Jeff Garzik <jeff@garzik.org>, Julian Calaby <julian.calaby@gmail.com>,
       adam radford <aradford@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFQ] New driver architecture questions
Message-ID: <20090515163626.GA15360@parisc-linux.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com> <4A0B858F.3080405@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com> <4A0B9B0D.6080006@garzik.org> <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com> <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com> <4A0CDB27.6090009@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 08:56:25AM -0600, Mukker, Atul wrote:
> [Atul] I think we are close, for example, memcpy API in the stack is osi_memcpy(), which translates to memcpy() on Linux and ScsiPortMoveMemory() on windows.

The solution to "We have some people who speak French and other people who
speak German" is not to invent Esperanto ;-)

Using one or the other internally is fine (we don't care what you do),
but we want to see memcpy().  By the way, the documentation I found for
ScsiPortMoveMemory() seems to indicate that it's memmove(), not memcpy().
Mapping memcpy() to ScsiPortMoveMemory() is fine ... but you can't
realiably go the other way.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
