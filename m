Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbYBZLob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbYBZLob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYBZLoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:44:23 -0500
Received: from ping.pong.ch ([212.103.71.101]:41922 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbYBZLoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:44:22 -0500
Date: Tue, 26 Feb 2008 12:44:19 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
       Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com,
       johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after
	2.6.25-rc1 (bisected, powerpc related?)
Message-ID: <20080226114419.GA5353@soziologie.ch>
References: <20080225112310.GA5516@soziologie.ch> <200802260052.57875.rjw@sisk.pl> <20080225235703.GA17530@lst.de> <200802260113.57875.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802260113.57875.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 01:13:56AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, 26 of February 2008, Christoph Hellwig wrote:
> > On Tue, Feb 26, 2008 at 12:52:56AM +0100, Rafael J. Wysocki wrote:
> > > > I'm not suggesting a partial revert; I just wonder which part of the
> > > > change is causing the problem, as part of the debugging process.

I debuged this a bit further by testing the 4 changed functions
individually. The problem only occurs with the new version of
xfs_lowbit64. 

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
