Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXI1Glo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXI1Glo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760106AbXI1Glf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:41:35 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39136 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758333AbXI1Gle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:41:34 -0400
Date: Fri, 28 Sep 2007 15:41:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mgross@linux.intel.com, linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-ID: <20070928064113.GA32532@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>, mgross@linux.intel.com,
	linux-pm <linux-pm@lists.linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070927232501.79f9f4bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927232501.79f9f4bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:25:01PM -0700, Andrew Morton wrote:
> On Wed, 26 Sep 2007 15:40:26 -0700 Mark Gross <mgross@linux.intel.com> wrote:
> > +int qos_add_requirement(int qos, char *name, s32 value);
> > +int qos_update_requirement(int qos, char *name, s32 new_value);
> > +void qos_remove_requirement(int qos, char *name);
> 
> It's a bit rude stealing the entire "qos" namespace like this - there are
> many different forms of QoS, some already in-kernel.
> 
> s/qos/pm_qos/g ?

lat_qos or something might be more suitable.. it's a latency property, not
a power management one (even if pm ends up being the primary user of it).
