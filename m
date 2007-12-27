Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbXL0Tbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbXL0Tbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXL0Tbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:31:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50306 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752068AbXL0Tbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:31:36 -0500
Date: Thu, 27 Dec 2007 11:31:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [BUG]  at mm/slab.c:3320
In-Reply-To: <20071227153235.GA6443@skywalker>
Message-ID: <Pine.LNX.4.64.0712271130200.30555@schroedinger.engr.sgi.com>
References: <20071220100541.GA6953@skywalker> <20071225140519.ef8457ff.akpm@linux-foundation.org>
 <20071227153235.GA6443@skywalker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007, Aneesh Kumar K.V wrote:

> On Tue, Dec 25, 2007 at 02:05:19PM -0800, Andrew Morton wrote:
> > On Thu, 20 Dec 2007 15:35:41 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > ------------[ cut here ]------------
> > > kernel BUG at mm/slab.c:3320!

An attempt to allocate from an offline node? What NUMA architecture did 
this occur on?

