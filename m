Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbYCNIHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbYCNIHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYCNIHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:07:08 -0400
Received: from bender.weihenstephan.org ([62.245.246.226]:33995 "EHLO
	bender.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYCNIHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:07:06 -0400
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 04:07:06 EDT
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: Linux UIO driver cache problem in PowerPC (fix)
Date: Fri, 14 Mar 2008 08:41:33 +0100
User-Agent: KMail/1.9.4
References: <169c03cb0803121222h5fca9cdal5af873cd2a700f4d@mail.gmail.com> <20080313081932.4edee290@dilbert.local> <fa686aa40803131453w1ebf8debsf41a7c17812e60ca@mail.gmail.com>
In-Reply-To: <fa686aa40803131453w1ebf8debsf41a7c17812e60ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803140841.33981.juergen127@kreuzholzen.de>
X-cff-LastScanner: pcre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 22:53, Grant Likely wrote:
> On Thu, Mar 13, 2008 at 1:19 AM, Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> > Am Wed, 12 Mar 2008 15:22:59 -0400
> >
> >  schrieb "Jean-Samuel Chenard" <jsamch@gmail.com>:
> >  > Hi,
> >
> >  Hi Jean-Samuel,
> >  thanks for your report. Please CC LKML if you find bugs like this. I
> >  also added Grant Likely (PPC Xilinx Virtex maintainer), as it seems to
> >  be a platform specific problem.
>
> Hmmm.  I'm not a memory handling expert so I don't know what's going
> on here.  Josh, does this look like anything that would be ppc405
> related?

The UIO also doesn't work on a MPC5200 CPU. With the additional 
pgprot_noncached() call now it works as expected.

Juergen
