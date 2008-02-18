Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYBRTIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYBRTIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYBRTIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:08:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39002 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYBRTIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:08:06 -0500
Date: Mon, 18 Feb 2008 11:07:06 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andi Kleen <andi@firstfloor.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080218110706.221d3015@laptopd505.fenrus.org>
In-Reply-To: <adalk5ijdu1.fsf@cisco.com>
References: <200802171025.30590.elendil@planet.nl>
	<20080217124650.576990ce@laptopd505.fenrus.org>
	<p73mypyxx6z.fsf@bingen.suse.de>
	<20080218085018.05f3190a@laptopd505.fenrus.org>
	<20080218171159.GA24090@basil.nowhere.org>
	<20080218093215.5cf611a8@laptopd505.fenrus.org>
	<adalk5ijdu1.fsf@cisco.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 10:53:42 -0800
Roland Dreier <rdreier@cisco.com> wrote:

> AFAIK mapping PCI memory WB is not allowed, so WC is really our only
> choice.

afaik that depends on the BAR being prefetchable or not.

(and by your argument, ioremap_cached() would not be useful, and since that was, until
2.6.25-rc1, the default behavior for ioremap(), would have caused massive problems)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
