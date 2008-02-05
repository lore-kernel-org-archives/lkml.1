Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYBESIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYBESIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYBESIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:08:01 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58003 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752314AbYBESIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:08:01 -0500
Date: Tue, 5 Feb 2008 10:08:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
In-Reply-To: <Pine.LNX.4.64.0802050952300.16488@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0802051007270.11705@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI> <47A81513.4010301@cosmosbay.com>
 <Pine.LNX.4.64.0802050952300.16488@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Pekka J Enberg wrote:

> Heh, sure, but it's not exported to userspace which is required for 
> slabinfo to display the statistics.

Well we could do the same as for numa stats. Output the global count and 
then add

c<proc>=count

?

