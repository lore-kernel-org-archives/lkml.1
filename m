Return-Path: <linux-kernel-owner+w=401wt.eu-S1767611AbXEDGe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767611AbXEDGe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767678AbXEDGe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:34:57 -0400
Received: from holomorphy.com ([66.93.40.71]:39300 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767611AbXEDGe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:34:57 -0400
Date: Thu, 3 May 2007 23:35:34 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
Message-ID: <20070504063534.GX19966@holomorphy.com>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 08:08:41PM -0700, Christoph Lameter wrote:
> Performance tests show a slight improvements in netperf (not a
> strong case for a performance improvement but removing the
> constructor has definitely no negative impact so why keep
> this around?).

Cache effects are not so easily visible. Cache profile results from
more realistic workloads (e.g. major macrobenchmarks) are more
appropriate for gauging this.


-- wli
