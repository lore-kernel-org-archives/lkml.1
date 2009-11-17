Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZKQMJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZKQMJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZKQMJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:09:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38135
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755607AbZKQMJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:09:17 -0500
Date: Tue, 17 Nov 2009 04:09:34 -0800 (PST)
Message-Id: <20091117.040934.190018835.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, pv-drivers@vmware.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32-rc3] net: Getting rid of the x86 dependency to
 built vmxnet3
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.0911161053050.23246@sbhatewara-dev1.eng.vmware.com>
References: <alpine.LRH.2.00.0910280910250.24555@sbhatewara-dev1.eng.vmware.com>
	<alpine.LRH.2.00.0911161053050.23246@sbhatewara-dev1.eng.vmware.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Mon, 16 Nov 2009 15:41:33 -0800 (PST)

> 
> Getting rid of the x86 dependency to built vmxnet3
> 
> From: Shreyas Bhatewara <sbhatewara@vmware.com>
> 
> This patch removes config dependency on x86 to build vmxnet3 driver. Thus 
> the driver can be built on big endian architectures now. Although vmxnet3 
> is not supported on VMs other than x86 architecture, all this code goes in 
> to ensure correctness. If the code is not dependent on x86, it should not 
> assume little endian architecture in any of its operations.
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

Patch applied, thanks for following up on this.
