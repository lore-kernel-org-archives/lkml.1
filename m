Return-Path: <linux-kernel-owner+w=401wt.eu-S965044AbXDLTtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbXDLTtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbXDLTtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:49:15 -0400
Received: from gw.goop.org ([64.81.55.164]:59173 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965044AbXDLTtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:49:14 -0400
Message-ID: <461E8D16.6060202@goop.org>
Date: Thu, 12 Apr 2007 12:48:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Pte drop ptep_get_and_clear paravirt op.patch
References: <200704120530.l3C5Ubs0022821@zach-dev.vmware.com>
In-Reply-To: <200704120530.l3C5Ubs0022821@zach-dev.vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> In shadow mode hypervisors, ptep_get_and_clear achieves the desired
> purpose of keeping the shadows in sync by issuing a native_get_and_clear,
> followed by a call to pte_update, which indicates the PTE has been
> modified.
>
> Direct mode hypervisors (Xen) have no need for this anyway, and will trap
> the update using writable pagetables.
>
> This means no hypervisor makes use of ptep_get_and_clear; there is no
> reason to have it in the paravirt-ops structure.  Change confusing
> terminology about raw vs. native functions into consistent use of
> native_pte_xxx for operations which do not invoke paravirt-ops.
>   

Looks OK to me.  Are you going to put this into the pvops queue?

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
