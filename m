Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYBWNrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYBWNrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYBWNro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:47:44 -0500
Received: from pih-relay06.plus.net ([212.159.14.133]:50249 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbYBWNrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:47:25 -0500
X-Greylist: delayed 1766 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2008 08:47:25 EST
Date: Sat, 23 Feb 2008 13:17:49 +0000
From: Charles Bailey <charles@hashpling.org>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Subject: Re: Question about your git habits
Message-ID: <20080223131749.GA5811@hashpling.org>
References: <200802221837.37680.chase.venters@clientec.com> <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr> <20080223014445.GK27894@ZenIV.linux.org.uk> <7vfxvk4f07.fsf@gitster.siamese.dyndns.org> <20080223020913.GL27894@ZenIV.linux.org.uk> <998d0e4a0802221823h3ba53097gf64fcc2ea826302b@mail.gmail.com> <998d0e4a0802221847m431aa136xa217333b0517b962@mail.gmail.com> <20080223113952.GA4936@hashpling.org> <998d0e4a0802230508w12f236baiaf2d9ab5f364670a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <998d0e4a0802230508w12f236baiaf2d9ab5f364670a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Plusnet-Relay: 243ca5111fa1e5deae0cdbdc9909802a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 02:08:35PM +0100, J.C. Pizarro wrote:
> 
> But if the repos are aggressively repacked then the bit to bit differences
> are not ~2 MiB.

It shouldn't matter how aggressively the repositories are packed or what
the binary differences are between the pack files are. git clone
should (with the --reference option) generate a new pack for you with
only the missing objects. If these objects are ~52 MiB then a lot has
been committed to the repository, but you're not going to be able to
get around a big download any other way.
