Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbZLPTLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbZLPTLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935209AbZLPTLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:11:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38008
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935239AbZLPTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:11:18 -0500
Date: Wed, 16 Dec 2009 11:11:16 -0800 (PST)
Message-Id: <20091216.111116.58695691.davem@davemloft.net>
To: jesse.brandeburg@intel.com
Cc: stern@rowland.harvard.edu, roger.oksanen@cs.helsinki.fi,
       jeffrey.t.kirsher@intel.com, bruce.w.allan@intel.com,
       peter.p.waskiewicz.jr@intel.com, john.ronciak@intel.com,
       e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: e100 REGRESSION in 2.6.32
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.WNT.2.00.0912160938450.5316@jbrandeb-desk1.amr.corp.intel.com>
References: <Pine.LNX.4.44L0.0912151712560.2643-100000@iolanthe.rowland.org>
	<alpine.WNT.2.00.0912160938450.5316@jbrandeb-desk1.amr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Date: Wed, 16 Dec 2009 10:21:31 -0800 (Pacific Standard Time)

> copied the netdev mailing list.  Alan thanks for the report, I wonder if 
> you can revert 98468efddb101f8a29af974101c17ba513b07be1 and see if that 
> fixes it?
> 
> Roger on the To: line made that change, which may have broken e100 for 
> your system.

Better figure out if that commit is the culprit soon as I just
submitted it to -stable last night.
