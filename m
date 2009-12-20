Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZLTNcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZLTNcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 08:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZLTNcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 08:32:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbZLTNcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 08:32:15 -0500
Subject: Re: CPU offline/online related hang with latest git
From: Peter Zijlstra <peterz@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4B2DF699.3090107@in.ibm.com>
References: <4B2DF699.3090107@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 14:31:27 +0100
Message-ID: <1261315887.4314.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 15:34 +0530, Sachin Sant wrote:
> With 2.6.33-rc1-git1 (dd59f6c..) i am having trouble with
> CPU hotplug on multiple architectures. Trying to offline
> a CPU results in a machine hang.

damnit, you're right.. it's getting stuck during hotplug on stop machine
some place.

didn't notice it because it didn't crash.. 

sorry for that :-(

