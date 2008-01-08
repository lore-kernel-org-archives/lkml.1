Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbYAHWK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbYAHWK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYAHWKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:10:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54176 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751343AbYAHWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:10:21 -0500
Date: Tue, 8 Jan 2008 14:10:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 02/19] free swap space on swap-in/activation
In-Reply-To: <20080108205958.947621624@redhat.com>
Message-ID: <Pine.LNX.4.64.0801081408280.4281@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com> <20080108205958.947621624@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Rik van Riel wrote:

> Free swap cache entries when swapping in pages if vm_swap_full()
> [swap space > 1/2 used?].  Uses new pagevec to reduce pressure
> on locks.

The pagevec function would be faster if the swap removal could be batched 
inside of the locks taken in remove_exclusive_swap_page.

Reviewed-by: Christoph Lameter <clameter@sgi.com>
