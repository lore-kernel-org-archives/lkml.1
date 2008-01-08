Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYAHWaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYAHWaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYAHWaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:30:19 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50784 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751500AbYAHWaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:30:17 -0500
Date: Tue, 8 Jan 2008 14:30:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mel@skynet.ie
Subject: Re: [patch 09/19] (NEW) more aggressively use lumpy reclaim
In-Reply-To: <20080108210007.257424941@redhat.com>
Message-ID: <Pine.LNX.4.64.0801081429150.4678@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com> <20080108210007.257424941@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Rik van Riel wrote:

> If normal pageout does not result in contiguous free pages for
> kernel stacks, fall back to lumpy reclaim instead of failing fork
> or doing excessive pageout IO.

Good. Ccing Mel. This is going to help higher order pages which is useful 
for a couple of other projects.

Reviewed-by: Christoph Lameter <clameter@sgi.com>
