Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZJXNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZJXNXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZJXNXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 09:23:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45436
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361AbZJXNXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 09:23:16 -0400
Date: Sat, 24 Oct 2009 06:23:39 -0700 (PDT)
Message-Id: <20091024.062339.83445567.davem@davemloft.net>
To: ddaney@caviumnetworks.com
Cc: cfriesen@nortel.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: Irq architecture for multi-core network driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AE0DB98.1000101@caviumnetworks.com>
References: <4AE0D14B.1070307@caviumnetworks.com>
	<4AE0D72A.4090607@nortel.com>
	<4AE0DB98.1000101@caviumnetworks.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>
Date: Thu, 22 Oct 2009 15:24:24 -0700

> Certainly this is one mode of operation that should be supported, but
> I would also like to be able to go for raw throughput and have as many
> cores as possible reading from a single queue (like I currently have).

You can't do this, at least within the same flow, since as you even
mention in your original posting this can result in packet reordering
which we must avoid as much as is possible.
