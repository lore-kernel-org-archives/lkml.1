Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYJTUYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYJTUYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYJTUX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:23:59 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47945 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbYJTUX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:23:58 -0400
Date: Mon, 20 Oct 2008 16:23:57 -0400
To: Alok Kataria <alokkataria1@gmail.com>
Cc: Antipov Dmitry <dmantipov@yandex.ru>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>, akataria@vmware.com
Subject: Re: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
Message-ID: <20081020202357.GF22851@csclub.uwaterloo.ca>
References: <673951224218937@webmail87.yandex.ru> <35f686220810171517y6632b4b2p3d251d43753eb3d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35f686220810171517y6632b4b2p3d251d43753eb3d6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 03:17:39PM -0700, Alok Kataria wrote:
> Can you try the attached debug patch, it puts a printk message and
> will let us know what exaclty is failing during the calibration
> process.
> There were some major changes in the 2.6.27 cycle related to tsc calibration.
> Apart from the unification for 32 and 64bit, some checks were added in
> the code to make the calibration process more robust, maybe this
> specific machine is more prone to SMI's than other, as a result the
> checks are a little to harsh for this one.

I recently had to disable the timer generating an SMI on our platform,
because it would cause FIFO overflows on serial ports and other
infrequent problems.  SMM/SMI is just a pain in the rear.

I haven't tried 2.6.27 yet, but have not had issues with 2.6.26 so far
(other than it seemingly breaking the SC1200's ide controller with
certain compact flash cards which I am still trying to track down, but
that isn't a Geode LX problem, that's a Geode SC1200 problem).

-- 
Len Sorensen
