Return-Path: <linux-kernel-owner+w=401wt.eu-S2992991AbXDDQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992991AbXDDQff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992992AbXDDQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:35:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45679 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992991AbXDDQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:35:34 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Brad Boyer <flar@allandria.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070404162234.GS4922@austin.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403212928.GA12951@cynthia.pants.nu>
	 <1175644642.10567.31.camel@shinybook.infradead.org>
	 <20070403221002.GA13210@cynthia.pants.nu>
	 <1175648051.10567.61.camel@shinybook.infradead.org>
	 <20070403230908.GA13471@cynthia.pants.nu>
	 <20070404162234.GS4922@austin.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 12:34:53 -0400
Message-Id: <1175704494.2774.33.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 11:22 -0500, Linas Vepstas wrote:
> The biggest problem would seem to be that the assignment would
> depend on the detection order; there don't seem to be unique 
> id's that would help udev consistently assign device names in 
> consistent order. 

Of course there are. The different types of ports have different device
numbers. As long as we don't do anything silly like putting all the
serial drivers on the same major number, we can tell them apart
relatively well.

-- 
dwmw2

