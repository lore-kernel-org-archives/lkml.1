Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZCJDag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZCJDag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 23:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZCJDa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 23:30:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59804 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZCJDa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 23:30:27 -0400
Date: Tue, 10 Mar 2009 04:49:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: reason for delay in arch/x86/kernel/traps.c::io_check_error()?
Message-ID: <20090310034939.GC11935@one.firstfloor.org>
References: <49B56F18.1050904@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B56F18.1050904@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 01:33:44PM -0600, Chris Friesen wrote:
> 
> Hi all,
> 
> I was just wondering about the basis for the delay in io_check_error(). 
>  The ICH7 manual doesn't have any mention of a delay being required 
> here--is it necessary for other hardware, something not mentioned in the 
> manual, or just an accident?

The complete NMI error logging handling does not really apply to any modern 
chipset; it's for ancient hardware (286, 386 generation). Those often
needed strange delays too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
