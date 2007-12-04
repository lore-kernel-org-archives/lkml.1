Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbXLDPjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbXLDPjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXLDPj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:39:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41863 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLDPj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:39:28 -0500
Date: Tue, 4 Dec 2007 07:37:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: <tovarekl@centrum.cz>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: EIP problem (kernel: BUG: unable to handle kernel NULL pointer)
Message-ID: <20071204073729.212c2b3f@laptopd505.fenrus.org>
In-Reply-To: <200712041540.24458@centrum.cz>
References: <200712041345.380@centrum.cz>
	<200712041540.24458@centrum.cz>
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

On Tue, 04 Dec 2007 15:40:15 +0100
<tovarekl@centrum.cz> wrote:

> 
> Hi Kernel Gurus,
> 
> Please find kindly the description of EIP problems below.
> I greatfully appreciate your kind help.
> 

Hi,

your oops is the first crash reported against generic_make_request in
2.6.18 (in fact, in the last year pretty much) so it's not a very
common pattern. However, you're running a 2.6.18 kernel, which is
really really old (and has many known security issues fixed since);
it's probably a good idea to do a yum upgrade to get a more current
kernel; fc6 ships something like a 2.6.22 or 2.6.23 nowadays as
update...

Greetings,
   Arjan van de Ven
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
