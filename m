Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYH1VVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYH1VVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbYH1VVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:21:39 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:61639 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbYH1VVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:21:38 -0400
Subject: Re: Frustrated with capabilities..
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Theodore Tso <tytso@mit.edu>
Cc: Markku Savela <msa@moth.iki.fi>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080828174854.GM26987@mit.edu>
References: <87hc96by8x.fsf@burp.tkv.asdf.org>
	 <20080828141826.GA6797@ucw.cz>
	 <200808281445.m7SEjYsB007502@burp.tkv.asdf.org>
	 <20080828174854.GM26987@mit.edu>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 17:03:19 -0400
Message-Id: <1219957399.2627.127.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 13:48 -0400, Theodore Tso wrote:
> On Thu, Aug 28, 2008 at 05:45:34PM +0300, Markku Savela wrote:
> > 
> > > From: Pavel Machek <pavel@suse.cz>
> > 
> > > Yes, you need upcoming filesystem capabilities.  Binary may not
> > > inherit capabilities unless filesystem flags permit that.
> > 
> > I think this is wrong. Normal executables inherit uid/gid and
> > supplementary groups by default. Why should capabilities be any
> > different?
> 
> Well, because that's not the what the POSIX draft specification (and
> the rest of the Unix industry who were striving to meet the US
> Department of Defense's "B2 by '92" initiative) ended up implementing.

Minor nit. It was actually C2(Controlled Access Protection) by '92 which
is mainly just DAC protections as opposed to B2(Structured Protection)
which also included MAC policies and Sensitivity labels in addition to
DAC protections.

Dave

