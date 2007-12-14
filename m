Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbXLNKRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbXLNKRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXLNKRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:17:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53899 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXLNKRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:17:08 -0500
Date: Fri, 14 Dec 2007 11:17:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214101720.GA10981@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214143941.2c7dcfb4@linux360.ro>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>so do whatever is necessary to enable dynticks. 

dynticks' main purpose is to save power, but C1e saves more power.
Disabling C1e for dynticks would be a fairly useless default
trade off.

-Andi
