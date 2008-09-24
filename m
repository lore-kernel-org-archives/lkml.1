Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYIXVXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYIXVXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYIXVXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:23:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:50358 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYIXVXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:23:41 -0400
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
	hardirq preemption
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Milton Miller <miltonm@bga.com>
Cc: Sebastien Dugue <sebastien.dugue@bull.net>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Christoph Raisch <RAISCH@de.ibm.com>, linuxppc-dev@ozlabs.org,
       Jan-Bernd Themann <ossthema@de.ibm.com>
In-Reply-To: <0fa2693104ff3250114d82837911b9e8@bga.com>
References: <200809231743.23828.ossthema@de.ibm.com>
	 <20080915100406.342e027a@bull.net>
	 <200809240958.m8O9wM7k010996@sullivan.realtime.net>
	 <20080924143055.6102f317@bull.net>
	 <0fa2693104ff3250114d82837911b9e8@bga.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 07:16:45 +1000
Message-Id: <1222291005.8277.86.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 11:42 -0500, Milton Miller wrote:
> 
> I was trying to understand why the mask and early eoi, but I guess its 
> to handle other more limited interrupt controllers where the interrupts 
> stack in hardware instead of software.

No Milton, we must do it that way, because the EOI must be done on the
right CPU even on XICS, or we won't get the CPU priority back properly.

Ben.

