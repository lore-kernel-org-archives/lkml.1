Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZKWL5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZKWL5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbZKWL5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:57:30 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60054 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111AbZKWL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:57:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rWyTNggKeWecEwVyv35usgpazawPBJd+8TqPOZpNxca/DOp45FiedueQjwW9jet86A
         iisFpmY8m85SMmoJyy8DFVg2o3gSvncrO9aHfVzm/uL/+zee8ZCAuvBM3ZI3joSgtxor
         bArQi/vj6OyPfq/MPNJlzbKJ6btMKug4koIww=
Date: Mon, 23 Nov 2009 12:57:16 +0100
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mel Gorman <mel@csn.ul.ie>,
       Roger Oksanen <roger.oksanen@cs.helsinki.fi>
Subject: Re: [Bug #14265] ifconfig: page allocation failure. order:5,
	mode:0x8020 w/ e100
Message-ID: <20091123115716.GB5256@bizet.domek.prywatny>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera> <mYW9sxtWd2G.A.3sF.jDACLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mYW9sxtWd2G.A.3sF.jDACLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 04:02:11PM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14265
> Subject		: ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
> Submitter	: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> Date		: 2009-09-15 12:05 (68 days old)
> References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4

Status of this bug in mainline didn't change. However, there are
patches to fix this issue:

  1. http://marc.info/?l=e1000-devel&m=125659409119946&w=2

Works -- interface is brought up properly.  However, kernel warns
about two allocation failures (and succeeds in thrid attempt).

Patches to make warnings appear every 10th failure have been
presented.  What this basically means for me is that failure message
would pop up every 5th suspend-resume cycle.

(Patch has a typo that needs fixing: s/struct cbs/struct cb/)


  2. http://marc.info/?l=e1000-devel&m=125637894721936&w=2

Works without any warnings.  Sadly, patch is far more intrusive.

Thanks.
