Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbZEQE5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbZEQE5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 00:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZEQE52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 00:57:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:51234 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZEQE51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 00:57:27 -0400
Date: Sat, 16 May 2009 21:57:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
Message-ID: <20090516215719.1fe0d583@infradead.org>
In-Reply-To: <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	<2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
	<alpine.DEB.1.10.0905151533070.13433@qirst.com>
	<2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
	<4A0EFA08.4060106@redhat.com>
	<20090517011906.GA6375@localhost>
	<93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com>
	<20090517020829.GB6809@localhost>
	<93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009 10:00:28 +0530
Satish Eerpini <eerpini@gmail.com> wrote:

> > I've prepared a rolled up patch for you, run time tested.  It should
> > protect all of the above pages from being evicted by large file
> > copies.
> >
> > The attached patch is for 2.6.29.
> 
> I applied the patch , but the number don seem to show much difference
> , following are the statistics with the patched kernel, could
> something else be causing the huge iowait,  :
> 


for i in `pidof kjournald` ; do ionice -c1 -p $i ; done

is another thing to try to fix the responsiveness...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
