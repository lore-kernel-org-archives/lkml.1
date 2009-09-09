Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbZIIVMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbZIIVMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZIIVMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:12:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:18132 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZIIVMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:12:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,360,1249282800"; 
   d="scan'208";a="549197459"
Date: Wed, 9 Sep 2009 14:12:15 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] X86: pci quirks, fix pci refcounting
Message-ID: <20090909141215.2db38836@jbarnes-g45>
In-Reply-To: <1252404978-14977-1-git-send-email-jirislaby@gmail.com>
References: <1252404978-14977-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Sep 2009 12:16:18 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Stanse found a pci reference leak in quirk_amd_nb_node.
> Instead of putting nb_ht, there is a put of dev passed as
> an argument.
> 
> http://stanse.fi.muni.cz/

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
