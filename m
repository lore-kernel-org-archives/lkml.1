Return-Path: <linux-kernel-owner+w=401wt.eu-S1751019AbXBMIdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbXBMIdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbXBMIdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:33:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55929 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXBMIdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:33:02 -0500
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
Date: Tue, 13 Feb 2007 09:29:49 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702130929.49349.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> In my understanding, a "node" is a block of cpu, memory, devices.
> and there could be cpu-only-node, memory-only-node, device-only-node...

The trouble with this is that you'll need to harden large parts
of code against these.  Especially a NULL pgdat is something quite
dangerous. You could make it a dummy empty pgdat, but just assigning it
nearby seems easier.

-Andi
