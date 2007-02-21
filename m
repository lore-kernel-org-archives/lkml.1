Return-Path: <linux-kernel-owner+w=401wt.eu-S1422930AbXBUUDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422930AbXBUUDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423014AbXBUUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:03:09 -0500
Received: from gw.goop.org ([64.81.55.164]:49602 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422930AbXBUUDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:03:04 -0500
Message-ID: <45DCA572.9090704@goop.org>
Date: Wed, 21 Feb 2007 12:02:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <ak@muc.de>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for paravirt_ops
 interface
References: <20070216022449.739760547@goop.org> <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com> <45D61C74.2000601@vmware.com> <Pine.LNX.4.64.0702161312460.28871@schroedinger.engr.sgi.com> <45D626BB.20007@vmware.com> <Pine.LNX.4.64.0702161356380.29218@schroedinger.engr.sgi.com> <20070217135112.GA15102@muc.de> <Pine.LNX.4.64.0702211036060.24941@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702211036060.24941@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> And it seems that the hooks are not generic but bound to a particular 
> hypervisor. Should the Xen specific stuff not be in the binary blob?

Xen has no "binary blob".  It needs guests to cooperate with it by
making hypercalls; all that code is in the Xen implementation of the
paravirt_ops interface, which is just ordinary code which lives in the
kernel sources.

    J

