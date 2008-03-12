Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYCLWtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYCLWtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYCLWs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:48:56 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:37824 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYCLWsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:48:55 -0400
Date: Wed, 12 Mar 2008 15:47:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Chris Wright <chrisw@sous-sol.org>, torvalds@osdl.org,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH, TRIVIAL] Fix default compose table
	initialization
Message-ID: <20080312224742.GE4416@sequoia.sous-sol.org>
References: <20080303012349.GA12338@implementation> <20080312212004.GD4416@sequoia.sous-sol.org> <20080312223355.GB4442@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080312223355.GB4442@implementation>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Samuel Thibault (samuel.thibault@ens-lyon.org) wrote:
> Chris Wright, le Wed 12 Mar 2008 14:20:04 -0700, a écrit :
> > * Samuel Thibault (samuel.thibault@ens-lyon.org) wrote:
> > > Oddly enough, unsigned int c = '\300'; puts a "negative" value in c, not
> > > 0300...  This fixes the default unicode compose table by using integers
> > > instead of character constants.
> > 
> > I think this patch breaks the s390 build, no?
> 
> Yes, that was reported and fixed iirc.

Care to send that along to stable, otherwise we'll just drop this one
from 2.6.24-stable queue.

thanks,
-chris
