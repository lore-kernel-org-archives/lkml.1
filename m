Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbYATQo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbYATQo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYATQow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:44:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43706 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbYATQov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:44:51 -0500
Date: Sun, 20 Jan 2008 17:48:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: ACPI early ioremap problems II
Message-ID: <20080120164817.GA26820@one.firstfloor.org>
References: <20080119030843.GA2028@basil.nowhere.org> <20080119150328.GA32370@elte.hu> <20080119152649.GA1375@one.firstfloor.org> <20080119153055.GA12054@elte.hu> <20080119154651.GA1626@one.firstfloor.org> <20080119184543.GA3751@elte.hu> <20080119191621.GA3865@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119191621.GA3865@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As a followup I see this problem on three different 64bit machines now.
Symptom is usually that only one core is active because ACPI doesn't
see the other processors in its tables.

-Andi

