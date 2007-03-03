Return-Path: <linux-kernel-owner+w=401wt.eu-S2992900AbXCCCGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992900AbXCCCGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 21:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992901AbXCCCGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 21:06:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:36666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992900AbXCCCGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 21:06:32 -0500
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] ehea: Optional TX/RX path optimized for SMP
References: <200702231730.58579.ossthema@de.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 Mar 2007 04:06:08 +0100
In-Reply-To: <200702231730.58579.ossthema@de.ibm.com>
Message-ID: <p73mz2vauvz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann <ossthema@de.ibm.com> writes:
> 
> Are there any concerns about this approach?

Yes. You should fix the NAPI code instead of trying to work
around it.

-Andi
