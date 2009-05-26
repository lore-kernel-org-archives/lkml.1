Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbZEZSIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbZEZSIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZEZSIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:08:35 -0400
Received: from hera.cwi.nl ([192.16.191.8]:57823 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbZEZSIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:08:35 -0400
Date: Tue, 26 May 2009 20:08:21 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Frans Pop <elendil@planet.nl>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Message-ID: <20090526180821.GB13276@ub>
References: <200905252344.11826.bzolnier@gmail.com> <200905260106.13705.elendil@planet.nl> <200905261423.40117.bzolnier@gmail.com> <200905261453.22428.elendil@planet.nl> <20090526140132.19e8bc13@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526140132.19e8bc13@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 02:01:32PM +0100, Alan Cox wrote:
> > Naive thought: wouldn't it be possible to check whether a partition 
> > overlaps the HPA boundary and warn or even bug out in that case?
> 
> No - believe me we all thought about that. The PC partition format has
> starts but not ends so you need detailed internal file system knowledge
> to play guessing games (which thus needs to be user space). Some of the
> non PC formats use the middle or end of disk so if you don't know the
> size you can't *find* the partition data.
> 
> Alan

Hi Alan,

Probably I am missing some context, but the above seems to be
a false statement. The PC partition format does give you
start and size, and no filesystem knowledge is needed to
find out where a partition ends.

Andries

