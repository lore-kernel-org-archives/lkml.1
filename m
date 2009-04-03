Return-Path: <linux-kernel-owner+w=401wt.eu-S935760AbZDCRyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935760AbZDCRyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbZDCRye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:54:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbZDCRyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:54:32 -0400
Date: Fri, 3 Apr 2009 13:53:55 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org
Subject: Re: Linux-2.6.29-git6 Compile Error
Message-ID: <20090403175355.GB26888@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
	linux-kernel@vger.kernel.org
References: <49D0D3DF.1050008@turknet.net.tr> <20090330143438.GA6736@elte.hu> <20090330164702.GA6372@redhat.com> <20090403174701.GF6295@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403174701.GF6295@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 07:47:01PM +0200, Ingo Molnar wrote:
 > 
 > * Dave Jones <davej@redhat.com> wrote:
 > 
 > > On Mon, Mar 30, 2009 at 04:34:38PM +0200, Ingo Molnar wrote:
 > >  > 
 > >  > (Cc: added)
 > > 
 > > See 199785eac892a1fa1b71cc22bec58e8b156d9311
 > > Steven picked up in this build failure _months_ ago in -next,
 > > which caused me to regenerate the cpufreq tree so that the build failure
 > > wouldn't get introduced to mainline.
 > > 
 > > Then the x86-merge comes along, and steamrollers over it.
 > 
 > hmmm ... there certainly was no build failure observable here. Which 
 > commit caused the problem? 199785eac8 went in via your tree, not the 
 > x86 tree.

The commits that moved the include file around reverted the changes
from 199785eac8.

	Dave
