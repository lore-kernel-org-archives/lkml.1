Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXDNXef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXDNXef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 19:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXDNXef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 19:34:35 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3252 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXDNXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 19:34:32 -0400
X-Server-Uuid: 20144BB6-FB76-4F11-80B6-E6B2900CA0D7
Subject: Re: intermittant petabyte usage reported with broadcom nic
From: "Michael Chan" <mchan@broadcom.com>
To: "CaT" <cat@zip.com.au>
cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070402074108.GB8345@zip.com.au>
References: <20070402014319.GA8345@zip.com.au>
 <20070402001300.3b66007d.akpm@linux-foundation.org>
 <20070402074108.GB8345@zip.com.au>
Date: Sat, 14 Apr 2007 17:20:01 -0700
Message-ID: <1176596401.5847.7.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6A3FBB7038G17105691-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 17:41 +1000, CaT wrote:
> On Mon, Apr 02, 2007 at 12:13:00AM -0700, Andrew Morton wrote:
> > On Mon, 2 Apr 2007 11:43:19 +1000 CaT <cat@zip.com.au> wrote:
> > 
> > > I take minute by minute snapshots of network traffic by sampling
> > > /proc/net/dev and most of the time everything works fine. Occasionally
> > > though I get petabyte byte traffic and corresponding packet traffic.
> > 
> > How frequently?
> 
> I can count about 6 over the past month.
> 
I did a quick test on a 64-bit kernel and did not see any problem with
the counters.  I'll ask the lab to set up a longer term test and monitor
the counters for bogus values.

I also like Andi's idea of using change_page_attr() to isolate the
problem.  I'll try to send you a debug patch in the next few days to try
that out.  Thanks.

