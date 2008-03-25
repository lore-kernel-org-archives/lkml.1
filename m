Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYCYR5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYCYR5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbYCYR47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:56:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57242 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756643AbYCYR46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:56:58 -0400
Date: Tue, 25 Mar 2008 10:55:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
In-Reply-To: <20080325075106.GF2170@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0803251054320.16374@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061726.782068299@sgi.com>
 <871w63iuap.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803241251360.4218@schroedinger.engr.sgi.com>
 <20080325075106.GF2170@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Andi Kleen wrote:

> Maybe sparse could be taught to check for this if it happens
> in a single function? (cc'ing Al who might have some thoughts
> on this). Of course if it happens spread out over multiple
> functions sparse wouldn't help neither. 

We could add debugging code to virt_to_page (or __pa) to catch these uses.

