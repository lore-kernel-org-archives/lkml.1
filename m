Return-Path: <linux-kernel-owner+w=401wt.eu-S1751262AbXCCI2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbXCCI2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 03:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXCCI2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 03:28:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:43435 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbXCCI2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 03:28:47 -0500
Subject: Re: [PATCH] ehea: Optional TX/RX path optimized for SMP
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan-Bernd Themann <ossthema@de.ibm.com>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
In-Reply-To: <p73mz2vauvz.fsf@bingen.suse.de>
References: <200702231730.58579.ossthema@de.ibm.com>
	 <p73mz2vauvz.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 09:28:28 +0100
Message-Id: <1172910508.8184.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-03 at 04:06 +0100, Andi Kleen wrote:
> Jan-Bernd Themann <ossthema@de.ibm.com> writes:
> > 
> > Are there any concerns about this approach?
> 
> Yes. You should fix the NAPI code instead of trying to work
> around it.

NAPI is being fixed but the fix will take time to get in. In the
meantime, the solution to get something working is the workaround.

Ben.


