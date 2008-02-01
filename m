Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYBATQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYBATQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759885AbYBATO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:14:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47114 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759853AbYBATO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:14:56 -0500
Date: Fri, 1 Feb 2008 11:14:51 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Jack Steiner <steiner@sgi.com>, Andrea Arcangeli <andrea@qumranet.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com
Subject: Re: [patch 1/4] mmu_notifier: Core code
In-Reply-To: <20080201105516.GK26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0802011114280.18163@schroedinger.engr.sgi.com>
References: <20080201050439.009441434@sgi.com> <20080201050623.112641539@sgi.com>
 <20080201105516.GK26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Robin Holt wrote:

> OK.  Now that release has been moved, I think I agree with you that the
> down_write(mmap_sem) can be used as our lock again and still work for
> Jack.  I would like a ruling from Jack as well.

Talked to Jack last night and he said its okay.

