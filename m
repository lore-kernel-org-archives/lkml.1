Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYAUCzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYAUCzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 21:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYAUCzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 21:55:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33291 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbYAUCzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 21:55:40 -0500
Date: Mon, 21 Jan 2008 03:59:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: ACPI early ioremap problems II
Message-ID: <20080121025911.GA2675@one.firstfloor.org>
References: <20080119030843.GA2028@basil.nowhere.org> <20080119150328.GA32370@elte.hu> <20080119152649.GA1375@one.firstfloor.org> <20080119153055.GA12054@elte.hu> <20080119154651.GA1626@one.firstfloor.org> <20080119184543.GA3751@elte.hu> <20080119191621.GA3865@one.firstfloor.org> <20080120164817.GA26820@one.firstfloor.org> <20080120235000.GA23512@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120235000.GA23512@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 12:50:00AM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > As a followup I see this problem on three different 64bit machines 
> > now. Symptom is usually that only one core is active because ACPI 
> > doesn't see the other processors in its tables.
> 
> to be able to have a chance to fix it we need you meet the minimum 
> threshold for bugreports: please send the failing .config and a full 
> boot message of the incident as well. (Please also check latest x86.git, 
> maybe it's something that got fixed today.)

The other crash seems to have gone away on git tip 
28a0fcd6b38e247200bd857996375aee91eae8ce now. I also don't see the missing 
nodes or missing cores anymore. Also the extended memory on AMD
seems to be detected correctly gain.

Thanks,

-Andi
