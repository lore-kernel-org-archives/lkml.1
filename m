Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXAaPG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXAaPG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964781AbXAaPG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:06:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:13254 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778AbXAaPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:06:58 -0500
Subject: Re: [PATCH 06/23] timekeeping: create kernel/time/timekeeping.c
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
In-Reply-To: <20070131085948.GA17473@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033804.860354489@mvista.com>  <20070131085948.GA17473@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 07:05:27 -0800
Message-Id: <1170255927.9781.15.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 09:59 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Move the generic timekeeping code from kernel/timer.c to 
> > kernel/time/timekeeping.c. [...]
> 
> please lets not do this just yet. While i have no problems with the 
> change in theory, the time code is in high flux and it's easier to keep 
> things sorted if we dont do big code movements. It also makes it harder 
> to review things and it acts as a hard merge barrier. We usually do such 
> move chunks of code in 'quiet periods', and now is definitely not such a 
> period. It's also pretty easy to do.

I'm not opposed to waiting .. I do think this needs to go in eventually
tho .. This is a clean up that John requested, and I only added it
because I was making other changes to timekeeping.. So it's really his
call .

Daniel

