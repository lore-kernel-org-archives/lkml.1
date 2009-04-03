Return-Path: <linux-kernel-owner+w=401wt.eu-S1761736AbZDCADY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761736AbZDCADY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZDCADQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:03:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51347 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZDCADQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:03:16 -0400
Date: Thu, 2 Apr 2009 17:02:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, niv@us.ibm.com,
       dvhltc@us.ibm.com, dhowells@redhat.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-ID: <20090403000257.GE6808@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090203183426.GA14409@linux.vnet.ibm.com> <20090329203118.GA14005@linux.vnet.ibm.com> <20090402223605.GB19007@elte.hu> <20090402154444.b143efcf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402154444.b143efcf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 03:44:44PM -0700, Andrew Morton wrote:
> On Fri, 3 Apr 2009 00:36:05 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > Andrew, what do you think?
> 
> I'm really struggling to see how the 900-odd bytes saved justifies
> creating (yet another) variant of core kernel machinery.
> 
> > A worry is yet another RCU variant - we already have 3.
> 
> That would make four?

Three, once treercu is deemed stable enough to permit dropping Classic RCU.

						Thanx, Paul
