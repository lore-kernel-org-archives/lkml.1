Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbXLSSgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbXLSSgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbXLSSgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:36:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50651 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbXLSSgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:36:06 -0500
Subject: Re: [PATCH] apm_event{,info}_t are userspace types.
From: Adam Jackson <ajax@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071212024700.19560b60.akpm@linux-foundation.org>
References: <1196452963295-git-send-email-ajax@redhat.com>
	 <20071212024700.19560b60.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 14:00:56 -0500
Message-Id: <1198090856.30771.236.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 02:47 -0800, Andrew Morton wrote:
> On Fri, 30 Nov 2007 15:02:43 -0500 Adam Jackson <ajax@redhat.com> wrote:
> > These types define the size of data read from /dev/apm_bios.  They
> > should not be hidden behind #ifdef __KERNEL__.
> 
> Missing info: what are the consequences of this fix?  What id broken when
> it it not applied?

The X server won't build.  Neither will apmd, but it's harder for me to
get worked up about that.

> > ---
> >  include/linux/apm_bios.h |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> Please include Signed-off-by:, as per Documentation/SubmittingPatches,
> thanks.

Blah.  Right, will remember git-format-patch -s next time.  In any
event:

Signed-off-by: Adam Jackson <ajax@redhat.com>

- ajax

