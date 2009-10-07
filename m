Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZJGTA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZJGTA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZJGTA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbZJGTAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:00:25 -0400
Date: Wed, 7 Oct 2009 20:59:52 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Olivier Galibert <galibert@pobox.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH][RFC] add MAP_UNLOCKED mmap flag
Message-ID: <20091007185952.GC19692@redhat.com>
References: <20091006190938.126F.A69D9226@jp.fujitsu.com>
 <20091006102136.GH9832@redhat.com>
 <20091006192454.1272.A69D9226@jp.fujitsu.com>
 <20091006103300.GI9832@redhat.com>
 <2f11576a0910060510y401c1d5ax6f17135478d22899@mail.gmail.com>
 <20091006121603.GK9832@redhat.com>
 <20091007185054.GB66690@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007185054.GB66690@dspnet.fr.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 08:50:54PM +0200, Olivier Galibert wrote:
> On Tue, Oct 06, 2009 at 02:16:03PM +0200, Gleb Natapov wrote:
> > I did. It allows me to achieve something I can't now. Steps you provide
> > just don't fit my needs. I need all memory areas (current and feature) to be
> > locked except one. Very big one. You propose to lock memory at some
> > arbitrary point and from that point on all newly mapped memory areas will
> > be unlocked. Don't you see it is different?
> 
> What about mlockall(MCL_CURRENT); mmap(...); mlockall(MCL_FUTURE);?
> Or toggle MCL_FUTURE if a mlockall call can stop it?
> 
This may work. And MCL_FUTURE can be toggled, but this is not thread
safe.
 
--
			Gleb.
