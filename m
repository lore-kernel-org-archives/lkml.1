Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbXHQUmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbXHQUmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbXHQUmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:42:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46541 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755286AbXHQUmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:42:00 -0400
Date: Fri, 17 Aug 2007 13:42:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Simple Performance Counters: Core Piece
In-Reply-To: <20070817164251.GA1004@Krystal>
Message-ID: <Pine.LNX.4.64.0708171340060.9404@schroedinger.engr.sgi.com>
References: <11859243123373-git-send-email-clameter@sgi.com>
 <20070817164251.GA1004@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Mathieu Desnoyers wrote:

> Actually, get_cycles() at least on some AMD cpus, do not synchronize the
> core, which can skew the results. You might want to use
> get_cycles_sync() there.

get_cycle() results as used here are bound to a single processor. If we 
end up on a different processor at the end of the measurement then the 
result is discarded. So not need for get_cycles_sync.

