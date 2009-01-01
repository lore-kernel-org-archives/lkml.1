Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZAAQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZAAQdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 11:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZAAQdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 11:33:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708AbZAAQdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 11:33:07 -0500
Date: Thu, 1 Jan 2009 08:32:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Andi Kleen <andi@firstfloor.org>, Jeff Arnold <jbarnold@MIT.EDU>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 1/7] Make section names compatible with
 -ffunction-sections -fdata-sections
Message-Id: <20090101083230.34cffeac.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0812311649180.2230@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
	<1228521840-3886-2-git-send-email-jbarnold@mit.edu>
	<8763lxwv0d.fsf@basil.nowhere.org>
	<alpine.DEB.2.00.0812311410070.2230@vinegar-pot.mit.edu>
	<20081231195215.GU496@one.firstfloor.org>
	<alpine.DEB.2.00.0812311649180.2230@vinegar-pot.mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008 16:59:39 -0500 (EST) Tim Abbott <tabbott@MIT.EDU> wrote:

> Hi Andrew,
> 
> I'd like to get this -ffunction-sections patch merged sometime during the 
> 2.6.29 merge window.  I've updated it in my git repository to work on top 
> of Linus' current master; how do you want to handle this?
> 

<tries to remember what the patch does, and what the problem with it is>
<finds it>

OK, it hits a lot of files in minor ways.

You could ask Linus to merge it late in the -rc1 merge window (please
cc me on the email).  Or you could just send it to me (with the usual
cc's) and I'll toss it into my 2.6.29-rc1 pile.  I doubt if it'll cause
much trouble.  But please do check its applicability to linux-next - people
have been moving arch files into different directories lately.
