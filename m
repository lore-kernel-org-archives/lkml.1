Return-Path: <linux-kernel-owner+w=401wt.eu-S1031386AbXEDQtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031386AbXEDQtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031395AbXEDQtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:49:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40731 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031386AbXEDQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:49:20 -0400
Date: Fri, 4 May 2007 09:49:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Frank van Maarseveen <frankvm@frankvm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20.6 kernel BUG at mm/slab.c:2877
In-Reply-To: <20070504145236.GA23954@janus>
Message-ID: <Pine.LNX.4.64.0705040948310.22097@schroedinger.engr.sgi.com>
References: <20070504145236.GA23954@janus>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Frank van Maarseveen wrote:

> 2.6.20.6, FYI,
> 
> This suddenly cropped up after starting to use the i915 and drm module
> but maybe it is unrelated to that:

Scribble? Looks like the slab metadata structurs were corrupted. This may 
occur if the slab metadata at the beginning of a slab page gets corrupted.

