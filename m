Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXJ2VfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXJ2VfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXJ2Ve5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:34:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbXJ2Ve4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:34:56 -0400
Date: Mon, 29 Oct 2007 14:34:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-kernel@vger.kernel.org, kay.sievers@suse.de,
       Michael_E_Brown@dell.com, zoz@suse.de, dkukawka@suse.de, trenn@suse.de,
       Douglas_Warzecha@dell.com, Anil_Rao@dell.com, davej@redhat.com,
       davidz@redhat.com, ben.collins@ubuntu.com
Subject: Re: [PATCH] dcdbas: add DMI-based module autloading
Message-Id: <20071029143434.a87fe371.akpm@linux-foundation.org>
In-Reply-To: <20071029212514.GA1328@humbolt.us.dell.com>
References: <20071029212514.GA1328@humbolt.us.dell.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 16:25:15 -0500
Matt Domsch <Matt_Domsch@dell.com> wrote:

> DMI autoload dcdbas on all Dell systems.
> 
> This looks for BIOS Vendor or System Vendor == Dell, so this should
> work for systems both Dell-branded and those Dell builds but brands
> for others.  It causes udev to load the dcdbas module at startup,
> which is used by tools called by HAL for wireless control and
> backlight control, among other uses.

fyi, I added this to the 2.6.25 queue.  If you think a patch should go into
2.6.24 then it is best to explicitly say that and to explain why.
