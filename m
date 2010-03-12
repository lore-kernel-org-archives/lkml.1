Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0CLKCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:02:32 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:45100 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab0CLKCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:02:31 -0500
Date: Fri, 12 Mar 2010 11:02:13 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: pjohn@mvista.com, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] MIPS: Fix compile error implicit declaration of function
 cpu_local_wrap
Message-ID: <20100312100212.GA4400@linux-mips.org>
References: <1268337816.29250.3.camel@localhost.localdomain>
 <4B994E0C.1010503@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B994E0C.1010503@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 12:09:48PM -0800, David Daney wrote:

> On 03/11/2010 12:03 PM, Philby John wrote:
> >The commit 38b7827fc removed cpu_local_xx macros that lead to
> >a compile error: implicit declaration of function 'cpu_local_wrap',
> >when compiled for the MIPS Cavium Octeon processors. Revert back
> >to old code.
> >
> >CC: Christoph Lameter<cl@linux-foundation.org>
> >CC: Tejun Heo<tj@kernel.org>
> >CC: David Daney<ddaney@caviumnetworks.com>
> >Signed-off-by: Philby John<pjohn@mvista.com>
> 
> Ralf is testing a different patch for this problem.

Already applied to the lmo tree a few days ago so NACK for the posted
patch.

  Ralf
