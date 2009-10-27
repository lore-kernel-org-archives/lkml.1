Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZJ0SZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZJ0SZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbZJ0SZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:25:20 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:14750 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbZJ0SZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=K5K6xyKqsWo8KbsEQAVMs3EByWUAY9XmXuoT90fCONnG6BKZbJYbk4CovT7cLNK+WQ
         2A82q7P63XWPvRpxUdXwyOLIAQf/ANhC6jNMzt0yV2cM38azpsCx0E7kqVKA/3CENAhs
         6KvBCc3LqQDWO60hOYmePF8OL1XJkVkR4cZ64=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [quilt patches] Staging: rt28x0: more cleanups
Date: Tue, 27 Oct 2009 19:24:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <200910252134.17360.bzolnier@gmail.com> <20091027174728.GE23368@kroah.com>
In-Reply-To: <20091027174728.GE23368@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910271924.40420.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009 18:47:28 Greg KH wrote:
> On Sun, Oct 25, 2009 at 09:34:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > More cleanups:
> > - run all files through scripts/Lindent
> > - convert C++ style comments to C style
> > - remove typedefs
> > 
> > As a result those drivers start looking Linux-like and become easier
> > to comprehend, also as an added bonus another 1.5 KLOC are gone..
> > 
> > The downside is that it will be harder now to port over updates from
> > the original vendor source code than it was in the past..
> > 
> > As usual all changes were tested with RT2860 and RT3070.
> > 
> > 
> > Cause patches are too big for a mailing list they are available at:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/bart/staging-rt28x0-more-cleanups/
> 
> Does this series have your 00/12 set in them as well?

Nope, this one is on top of 00/12 set.

-- 
Bartlomiej Zolnierkiewicz
