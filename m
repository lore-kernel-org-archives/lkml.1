Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbXCDQ2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbXCDQ2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXCDQ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:28:06 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64192 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbXCDQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:28:05 -0500
Subject: Re: [PATCH -mm][Take 2] clocksource init adjustments (fix bug
	#7426)
From: Daniel Walker <dwalker@mvista.com>
To: john stultz <johnstul@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, andreas.friedrich@fujitsu-siemens.com,
       tglx@linutronix.de
In-Reply-To: <1172877840.5449.39.camel@localhost.localdomain>
References: <1172189582.5422.26.camel@localhost.localdomain>
	 <20070302021827.7edc1a23.akpm@linux-foundation.org>
	 <1172865491.5449.13.camel@localhost.localdomain>
	 <20070302.123202.11628478.davem@davemloft.net>
	 <1172877840.5449.39.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 08:25:35 -0800
Message-Id: <1173025535.31337.15.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 15:24 -0800, john stultz wrote:

> Thus the solution here is to register clocksources earlier (ideally when
> the hardware is being initialized), and then we enable clocksource
> selection at fs_initcall (before device_initcall).
> 

When I was doing this in my tree I found that registering clocksources
earlier would always break dynamic tick .. If dynamic tick switches
itself on during boot up then it usually hangs the system .. Did you
test this patch with that option enabled? (I haven't had a chance too..)

Daniel

