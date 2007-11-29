Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbXK2SQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbXK2SQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXK2SQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:16:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59614 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932540AbXK2SQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:16:17 -0500
Date: Thu, 29 Nov 2007 10:16:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/10] s390: Use generic percpu
In-Reply-To: <1196351761.23168.2.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711291016070.25304@schroedinger.engr.sgi.com>
References: <20071128210926.008783214@sgi.com>  <20071128211527.373111512@sgi.com>
 <1196351761.23168.2.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Martin Schwidefsky wrote:

> On Wed, 2007-11-28 at 13:09 -0800, Christoph Lameter wrote:
> > s390 has a special way to determine the pointer to a per cpu area
> > plus there is a way to access the base of the per cpu area of the
> > currently executing processor.
> > 
> > Note: I had to do a minor change to ASM code. Please check that
> > this was done right.
> 
> Hi Christoph,
> 
> after fixing the trainwreck with Gregs kset changes I've got rc3-mm2
> compiled with your percpu patches. The new s390 percpu code works fine:
> 
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Thank you.

