Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYAVUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYAVUbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYAVUbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:31:10 -0500
Received: from relay1.sgi.com ([192.48.171.29]:51025 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752952AbYAVUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:31:09 -0500
Date: Tue, 22 Jan 2008 12:31:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrea Arcangeli <andrea@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, daniel.blueman@quadrics.com,
       holt@sgi.com, steiner@sgi.com, Andrew Morton <akpm@osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] mmu notifiers #v3
In-Reply-To: <1201030127.6341.39.camel@lappy>
Message-ID: <Pine.LNX.4.64.0801221230340.28197@schroedinger.engr.sgi.com>
References: <20080113162418.GE8736@v2.random>  <20080116124256.44033d48@bree.surriel.com>
 <478E4356.7030303@qumranet.com>  <20080117162302.GI7170@v2.random>
 <478F9C9C.7070500@qumranet.com>  <20080117193252.GC24131@v2.random> 
 <20080121125204.GJ6970@v2.random> <1201030127.6341.39.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Peter Zijlstra wrote:

> I think we can get rid of this rwlock as I think this will seriously
> hurt larger machines.

Correct.

