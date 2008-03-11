Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYCKE2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYCKE2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYCKE2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:28:38 -0400
Received: from phunq.net ([64.81.85.152]:50130 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751772AbYCKE2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:28:37 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 10 Mar 2008 20:28:29 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <20080310092213.7ba878b3@core> <20080310150116.72c9f583@bree.surriel.com>
In-Reply-To: <20080310150116.72c9f583@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102128.29826.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008 12:01, Rik van Riel wrote:
> > Ext3 is only going to help you if the ramdisk writeback respects barriers
> > and ordering rules ?
> 
> That could get ugly when ext3 has written to the same block multiple
> times.  To get some level of consistency, ramback would need to keep
> around the different versions and flush them in order.

Ah, keep snapshots like ddsnap?  Interesting idea.  But complex, and
ramback will stay perfectly consistent so long as you don't pull the
plug on your UPS.  I seem to recall that EMC has been peddling SAN
storage with similar restrictions for quite some time now.

Regards,

Daniel
