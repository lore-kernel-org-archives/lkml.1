Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZBWITd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZBWITd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZBWITZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:19:25 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38764 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZBWITZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:19:25 -0500
Subject: Re: [patch 2/2] slub: add min_partial sysfs tunable
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0902221712160.26165@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0902221712160.26165@chino.kir.corp.google.com>
Date: Mon, 23 Feb 2009 10:19:22 +0200
Message-Id: <1235377162.6216.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, 2009-02-22 at 17:40 -0800, David Rientjes wrote:
> Now that a cache's min_partial has been moved to struct kmem_cache, it's
> possible to easily tune it from userspace by adding a sysfs attribute.
> 
> It may not be desirable to keep a large number of partial slabs around if
> a cache is used infrequently and memory, especially when constrained by a
> cgroup, is scarce.  It's better to allow userspace to set the minimum
> policy per cache instead of relying explicitly on kmem_cache_shrink().

The patches look good but the description is bit lacking. Does this
actually fix up something? Why don't we fix the limit calculations
instead?

I'm a sucker for numbers so I'm easily fooled into merging patches with
statements of the form "this shaves off N bytes/kb/mb on XYZ systems".

			Pekka

