Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXHVS3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXHVS3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761078AbXHVS3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:29:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40114 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690AbXHVS3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:29:35 -0400
Date: Wed, 22 Aug 2007 13:28:59 -0500
To: Paul Mackerras <paulus@samba.org>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppc: remove unused amiga_request_irq and mach_request_irq
Message-ID: <20070822182859.GX4261@austin.ibm.com>
References: <1187767237.25624.11.camel@sebastian.kern.oss.ntt.co.jp> <18124.1417.743332.974941@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18124.1417.743332.974941@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 07:44:41PM +1000, Paul Mackerras wrote:
> Fernando Luis Vázquez Cao writes:
> 
> > amiga_request_irq and mach_request_irq are never used, so delete them.
> 
> OK, but is there a particular reason you want to do this?
> 
> The whole of arch/ppc is going away eventually, so I don't think we
> need to remove it piece by piece.

Its often easier to port/move stuff if you clean it up first.

--linas
