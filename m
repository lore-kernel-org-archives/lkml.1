Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbZKZQ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbZKZQ2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760786AbZKZQ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:28:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:35167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760782AbZKZQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:28:11 -0500
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <4B0EAC06.3010407@linux.vnet.ibm.com>
References: <4B0EA88E.3030205@linux.vnet.ibm.com>
	 <1259252382.31676.207.camel@laptop>  <4B0EAC06.3010407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 17:28:12 +0100
Message-ID: <1259252892.31676.220.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 17:25 +0100, Christian Ehrhardt wrote:
> > Aside from that, we probably should put an upper limit in place, as I
> > guess large cpu count machines get silly large values
> I agree to that, but in the code is already an upper limit of 
> 200.000.000 - well we might discuss if that is too low/high.

Yeah, I think we should cap it around the 8-16 CPUs.

