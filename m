Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZAGQBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZAGQBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZAGQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:01:16 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57849 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZAGQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:01:16 -0500
Date: Wed, 7 Jan 2009 17:00:39 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpu: create stop machine in disable_nonboot_cpus
Message-ID: <20090107160039.GB25560@osiris.boeblingen.de.ibm.com>
References: <1231342755-5122-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231342755-5122-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 04:39:15PM +0100, Jiri Slaby wrote:
> Commit
> 772cd49cfa4002439b16dd6b553a11771ac096fd
> (stop_machine: introduce stop_machine_create/destroy.)
> introduced stop_machine_create/destroy, but omitted to call them from
> disable_nonboot_cpus (it's called only from cpu_down).
> 
> Create and destroy the stop machine even in disable_nonboot_cpus
> (which calls _cpu_down too) to avoid NULL-pointer dereference oops on
> suspend.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

Yep, it's exactly the same what I had as well:

http://lkml.org/lkml/2009/1/7/67

Thanks ;)
