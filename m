Return-Path: <linux-kernel-owner+w=401wt.eu-S1765360AbXHARwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765360AbXHARwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXHARwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:52:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43020 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760635AbXHARwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:52:24 -0400
Date: Wed, 1 Aug 2007 10:52:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
In-Reply-To: <p73ir7zplty.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com>
References: <11859243121617-git-send-email-clameter@sgi.com>
 <p73ir7zplty.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, Andi Kleen wrote:

> Christoph Lameter <clameter@sgi.com> writes:
> 
> > Export cycles_to_ns (after renaming the cycles_2_ns to cycles_to_ns to be
> > conforming to other arches).
> 
> This function is broken in some cases (e.g Opteron with powernow or
> AMD dual core or older Intel systems) and going away.  The TSCs tick
> with different frequencies on different CPU there. In general i would
> recommend to only report cycles.

But then the numbers are not comparable across systems.

