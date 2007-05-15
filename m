Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbXEORey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbXEORey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761776AbXEORep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:34:45 -0400
Received: from squawk.glines.org ([72.36.206.66]:51454 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761933AbXEORen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:34:43 -0400
Date: Tue, 15 May 2007 10:34:40 -0700
From: Mark Glines <mark@glines.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: select(0, ..) is valid ?
Message-ID: <20070515103440.696577b7@chirp>
In-Reply-To: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
Organization: Glines.org
X-Mailer: Claws Mail 2.9.0 (GTK+ 2.10.12; i686-pc-linux-gnu)
X-Useless-Header: yay!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 10:29:18 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> Hi,
> 
> Is select(0, ..) is a valid operation ?

select(0, ..) is rather commonly used as a portable sleep() with
microsecond granularity.  Disabling it will break lots of things.

Mark
