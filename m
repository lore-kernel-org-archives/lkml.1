Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYJUSI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYJUSI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYJUSIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:08:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37012 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYJUSIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:08:17 -0400
Date: Tue, 21 Oct 2008 20:15:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
Message-ID: <20081021181536.GI12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1> <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1> <20081021174008.GH12825@one.firstfloor.org> <1224612294.6161.43.camel@alok-dev1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224612294.6161.43.camel@alok-dev1>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIU from the code, even if  cpu A's TSC is just 1 tick behind that of
> cpu B, we increment the nr_wraps value.
> And the code expects that there are no wraps in TSC throughout the
> 20msec measurement window. 
> So IMO its fairly easy to fail this test.

Ok I think it would be better to enlarge the margin then to fix your
issue.

-Andi
