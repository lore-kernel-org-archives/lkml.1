Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXFLXnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXFLXnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbXFLXnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:43:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbXFLXnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:43:42 -0400
Date: Tue, 12 Jun 2007 19:42:39 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fix placement of inline keyword.
Message-ID: <20070612234239.GB20229@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070612233035.GA24146@redhat.com> <20070612233842.GJ3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612233842.GJ3588@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 01:38:42AM +0200, Adrian Bunk wrote:
 > On Tue, Jun 12, 2007 at 07:30:35PM -0400, Dave Jones wrote:
 > 
 > > gcc gets whiney about the placement of 'inline' at some warning levels.
 > >...
 > 
 > Since most of them are in C files, can you remove these when you are at it?

I'm not that motivated.  I did these to reduce some warning noise
a while back.  I just wanted to toss this out there before I dropped
it on the floor.  If it gets applied, great, if not, I'm not going to
be too bothered.

In many cases, there are lots of other inlines in those drivers too,
so it's a bigger job than the obvious fix that I did.

	Dave

-- 
http://www.codemonkey.org.uk
