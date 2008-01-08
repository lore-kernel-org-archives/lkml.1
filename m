Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYAHWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYAHWmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYAHWmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:42:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55493 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286AbYAHWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:42:04 -0500
Date: Tue, 8 Jan 2008 14:42:03 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
In-Reply-To: <20080108173634.5ed3b0d4@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0801081441090.4678@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com> <20080108210002.638347207@redhat.com>
 <Pine.LNX.4.64.0801081421530.4281@schroedinger.engr.sgi.com>
 <20080108173634.5ed3b0d4@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Rik van Riel wrote:

> > Also would it be possible to create generic functions that can move pages 
> > in pagevecs to an arbitrary lru list?
> 
> What would you use those functions for?

We keep on duplicating the pagevec lru operation functions in mm/swap.c. 
Some generic stuff would reduce the code size.
