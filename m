Return-Path: <linux-kernel-owner+w=401wt.eu-S1764447AbYD3WzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764447AbYD3WzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbYD3Wyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:54:44 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40134 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756592AbYD3Wym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:54:42 -0400
Subject: Re: [PATCH 02/10] scsi: fix integer as NULL pointer warnings
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1209594888.24729.130.camel@brick>
References: <1209593020.24729.112.camel@brick>
	 <1209594551.3774.37.camel@localhost.localdomain>
	 <1209594888.24729.130.camel@brick>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 17:54:38 -0500
Message-Id: <1209596078.3774.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 15:34 -0700, Harvey Harrison wrote:
> On Wed, 2008-04-30 at 17:29 -0500, James Bottomley wrote:
> > On Wed, 2008-04-30 at 15:03 -0700, Harvey Harrison wrote:
> > > drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
> > > drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
> > > drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer
> 
> > The flashpoint initialiser changes look wrong:  {0} is a conventional
> > notation for zero initialise this structure.  Sparse should probably be
> > taught to recognise that.
> 
> Actually, looking closer, should this be initialized at all?  Can we
> just remove the initialization here and let them end up in .bss?

Yes, but the conventional initialiser doesn't change that (as in zero
initialise a static and it ends up in bss anyway).

James


