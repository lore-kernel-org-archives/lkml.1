Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbYCNCUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbYCNCUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYCNCUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:20:47 -0400
Received: from phunq.net ([64.81.85.152]:44634 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752116AbYCNCUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:20:46 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 18:20:20 -0800
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Chris Friesen <cfriesen@nortel.com>,
       Lars Marowsky-Bree <lmb@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803120117.57644.phillips@phunq.net> <20080313163431.7b4058ef@cuia.boston.redhat.com>
In-Reply-To: <20080313163431.7b4058ef@cuia.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131920.21605.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 13:34, Rik van Riel wrote:
> On Wed, 12 Mar 2008 00:17:56 -0800
> Daniel Phillips <phillips@phunq.net> wrote:
> 
> > So we have a flock of people arguing that you can't trust Linux.  Well
> > maybe there are situations were you can't, but what can you trust?
> > Disk firmware?  Bios?  Big maybes everywhere.
> 
> The traditional and proven method to constructing a reliable system is
> to assume that no component can be fully trusted.  This is especially
> true for new code.
> 
> By being paranoid about everything, failures in one component are
> usually contained well enough that one failure is not catastrophic.
> 
> In order for ramback to get appeal with the people who are paranoid
> about data integrity (probably a vast majority of users), you will
> need some guarantees about flush order, etc...

I disagree.  Never mind that it already does provide such guarantees,
just echo 1 >/proc/driver/ramback/name.  But if you want the full
performance you need to satisfy your paranoia at a higher level in
the traditional way: by running two in parallel or whatever.

Daniel 
