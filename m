Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZDTNIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZDTNIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZDTNI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:08:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37502 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbZDTNI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:08:28 -0400
Date: Mon, 20 Apr 2009 15:11:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: John Hughes <john@Calva.COM>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Am I allowed to call request_firmware_nowait from an interrupt handler?
Message-ID: <20090420131148.GY14687@one.firstfloor.org>
References: <49EC60BC.1070501@Calva.COM> <87ab6bpmc8.fsf@basil.nowhere.org> <49EC7200.9080308@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC7200.9080308@Calva.COM>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 03:00:48PM +0200, John Hughes wrote:
> Andi Kleen wrote:
> >John Hughes <john@Calva.COM> writes:
> >  
> >>Am I being a naughty boy?
> >>    
> >
> >Yes.
> >
> >  
> Buggeration.  What an irritating restriction.
> 
> So I'll have to make a thread to do the firmware download, in which case 
> I can just use request_firmware instead of request_firmware_nowait.
> 
> Or can I use schedule_work?

That's what it is for yes.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
