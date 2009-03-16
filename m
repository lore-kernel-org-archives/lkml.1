Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZCPPW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZCPPW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZCPPWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:22:50 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:50877 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZCPPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vsOoz6VRAIz6rYIXpTUtS7012LIj+N3ijItlV9ZPIZMIk0AEqtiifqLCFolNeYTFOa
         GZYKQZkTZayv4scIhxFbiG2xUQCqvfH35wp9sJ3ettWZCPmWjCo3GSjptfHhbS1h3n87
         D4TLyh7P2Km9yjwZ2lylbHCiCOIaAhVZBD7Ks=
Date: Mon, 16 Mar 2009 18:29:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v3 PATCH 3/4] timers: /proc/sys sysctl hook to enable timer
	migration
Message-ID: <20090316152956.GA2344@x200.localdomain>
References: <20090316111045.GA4686@linux.vnet.ibm.com> <20090316111444.GD4686@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316111444.GD4686@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 04:44:44PM +0530, Arun R Bharadwaj wrote:
> echo 0 > /proc/sys/kernel/timer_migration

There should be no sysctl for this.

Timer migration should be good enough to be always enabled.
