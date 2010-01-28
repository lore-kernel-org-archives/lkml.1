Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463Ab0A1OzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0A1OzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 09:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596Ab0A1OzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 09:55:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab0A1OzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 09:55:15 -0500
Subject: Re: [PATCH 3/3] [RFC] nmi_watchdog: config option to enable new
 nmi_watchdog
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1264622622-5778-4-git-send-email-dzickus@redhat.com>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
	 <1264622622-5778-4-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 15:54:54 +0100
Message-ID: <1264690494.4283.2103.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 15:03 -0500, Don Zickus wrote:
> These are the bits that enable the new nmi_watchdog and safely isolate the
> old nmi_watchdog.  Only one or the other can run, not both at the same
> time.

perf disables the lapic watchdog when it wants the pmu, so there
shouldn't be a problem having both built in.

