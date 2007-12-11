Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbXLKPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbXLKPL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbXLKPLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:11:49 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:37559 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLKPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:11:48 -0500
Date: Tue, 11 Dec 2007 16:11:43 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [RFC] Proposed new directory layout for kvm and virtualization
Message-ID: <20071211151143.GA7751@osiris.boeblingen.de.ibm.com>
References: <475E5CBB.9080608@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475E5CBB.9080608@qumranet.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 11:47:39AM +0200, Avi Kivity wrote:
> KVM is due to receive support for multiple architectures (ppc, ia64, and 
> s390, in addition to the existing x86), hopefully in time for the 2.6.25 
> merge window.  It is awkward to place the new arch support in drivers/kvm/, 
> so I'd like to propose the following new layout:
> ...
>  arch/*/kvm/   arch dependent kvm code

Maybe arch/*/virt/ ? No need to add an own directory for each hypervisor.
