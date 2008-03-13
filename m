Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYCMTDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYCMTDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYCMTDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:03:11 -0400
Received: from phunq.net ([64.81.85.152]:52057 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754697AbYCMTDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:03:11 -0400
From: Daniel Phillips <phillips@phunq.net>
To: ric@emc.com
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 11:02:47 -0800
User-Agent: KMail/1.9.5
Cc: Lars Marowsky-Bree <lmb@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <47D92BBB.6000203@emc.com>
In-Reply-To: <47D92BBB.6000203@emc.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131202.48135.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 06:27, Ric Wheeler wrote:
> >>> So "perfectly reliable if UPS power does not fail" seems a bit over the
> >>> top.
> >> It works for EMC :-)
> > 
> > Where they control the hardware and run a rather specialized OS as well,
> > not a general purpose system like Linux on "commodity" hardware ;-)
> 
> Actually, in Centera we use generic hardware with a fairly normal kernel 
> which has strategic backports from upstream (libata, nic drivers, etc).
> 
> No UPS in the picture.  Data integrity is protected by working with the 
> application team to insure they understand when data is safely on the 
> disk platter and working with IO & FS people to try and make sure we 
> don't lie to them (too much ) about that promise.
> 
> The centera boxes are tested with power failure & error injection and by 
> all of our customers in all those ways customers do ;-)

Hi Ric,

Right, so Linux has gotten to the point where it competes with purpose-
built embedded software in reliability.  Not quite there, but close
enough for mission-critical.

I was not thinking of Centera when I mentioned the UPS though...

Daniel
