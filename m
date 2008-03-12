Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYCLWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYCLWeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYCLWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:34:09 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:38489 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbYCLWeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:34:08 -0400
Date: Wed, 12 Mar 2008 22:33:55 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: torvalds@osdl.org, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH,TRIVIAL] Fix default compose table initialization
Message-ID: <20080312223355.GB4442@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Chris Wright <chrisw@sous-sol.org>, torvalds@osdl.org,
	stable@kernel.org, linux-kernel@vger.kernel.org
References: <20080303012349.GA12338@implementation> <20080312212004.GD4416@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080312212004.GD4416@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright, le Wed 12 Mar 2008 14:20:04 -0700, a écrit :
> * Samuel Thibault (samuel.thibault@ens-lyon.org) wrote:
> > Oddly enough, unsigned int c = '\300'; puts a "negative" value in c, not
> > 0300...  This fixes the default unicode compose table by using integers
> > instead of character constants.
> 
> I think this patch breaks the s390 build, no?

Yes, that was reported and fixed iirc.

Samuel
