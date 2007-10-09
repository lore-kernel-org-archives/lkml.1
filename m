Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXJIS3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXJIS3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXJIS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:28:58 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33643 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbXJIS25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:28:57 -0400
Date: Tue, 9 Oct 2007 14:28:57 -0400
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
Message-ID: <20071009182857.GF4003@csclub.uwaterloo.ca>
References: <20071008220720.GF3484@elf.ucw.cz> <470AAFD7.9060002@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470AAFD7.9060002@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 03:31:51PM -0700, Kok, Auke wrote:
> you most certainly want to do this in userspace I think.
> 
> One of the biggest problems is that link negotiation can take a significant amount
> of time, well over several seconds (1 to 3 seconds typical) with gigabit, and
> having your ethernet connection go offline for 3 seconds may not be the desired
> effect for when you want to get more bandwidth in the first place.
> 
> However, when a laptop is in battery mode, switching down from gigabit to 100mbit
> makes a lot more sense, so this is something I would recommend. This can be as
> easy as changing the advertisement mask of the interface and renegotiating the
> link. Userspace could handle that very easily.

Now if you were trying to transfer a lot of data to the laptop, would it
be more power efficient to do it at gigabit speeds so you can finish
sooner and shut down the machine entirely, or to slow to 100mbit and
take longer to do it, and hence spend more time powering the cpu and
ram?

--
Len Sorensen
