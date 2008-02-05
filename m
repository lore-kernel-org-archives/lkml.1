Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYBEMMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYBEMMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYBEMMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:12:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYBEML7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:11:59 -0500
Date: Tue, 5 Feb 2008 12:11:52 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Igor M Podlesny <for.poige+linux@gmail.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: > You may find that you need to update your lvm userspace tools.
Message-ID: <20080205121152.GA609@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Igor M Podlesny <for.poige+linux@gmail.com>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com> <20080202235103.20dd9768.akpm@linux-foundation.org> <47A71040.5000300@gmail.com> <20080204052709.12f4e0d3.akpm@linux-foundation.org> <47A7F4DB.3070406@gmail.com> <20080204215304.8b909402.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204215304.8b909402.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 09:53:04PM -0800, Andrew Morton wrote:
> Could someone in dm-devel land please get involved?

Vague reports like this are sadly a regular occurrence, and they usually
happen when people don't update their initrd after updating their
kernel.  As well as the obvious problems from incompatible modules, some
versions of distros are worse than others, as they foolishly hard-code
device numbers, and a new kernel happens to assign device numbers in a
different sequence breaking everything.  Another cause is when the
distro lets the boot script run too early without waiting for the kernel
to discover all the devices necessary.  Or sometimes kernel/module
changes mean it no longer sees the devices at all.

Alasdair
-- 
agk@redhat.com
