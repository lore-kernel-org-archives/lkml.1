Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbXLEV25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbXLEV25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbXLEV2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:28:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57194 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbXLEV2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:28:47 -0500
Date: Wed, 5 Dec 2007 13:26:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Holger.Wolf@de.ibm.com
Cc: wolf@linux.vnet.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler behaviour
Message-ID: <20071205132631.79940bd5@laptopd505.fenrus.org>
In-Reply-To: <475706E2.50805@linux.vnet.ibm.com>
References: <475706E2.50805@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Dec 2007 21:15:30 +0100
Holger Wolf <wolf@linux.vnet.ibm.com> wrote:

> We discovered performance degradation with dbench when using kernel
> 2.6.23 compared to kernel 2.6.22.
> 
> In our case we booted a Linux in a IBM System z9 LPAR with 256MB of
> ram with 4 CPU's. This system uses a striped LV with 16 disks on a
> Storage Server connected via 8 4GBit links.
> A dbench was started on that system performing I/O operations on the
> striped LV. dbench runs were performed with 1 to 62 processes.
> Measurements with a 2.6.22 kernel were compared to measurements with
> a 2.6.23 kernel. We saw a throughput degradation from 7.2 to 23.4

this is good news!
dbench rewards unfair behavior... so higher dbench usually means a
worse kernel ;)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
