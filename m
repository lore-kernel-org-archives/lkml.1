Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYDHUXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYDHUXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYDHUXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:23:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33474 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753067AbYDHUXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:23:35 -0400
Date: Tue, 8 Apr 2008 13:23:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/10] emm: notifier logic
In-Reply-To: <20080407071330.GH9309@duo.random>
Message-ID: <Pine.LNX.4.64.0804081320160.30874@schroedinger.engr.sgi.com>
References: <20080404223048.374852899@sgi.com> <20080404223131.469710551@sgi.com>
 <20080405005759.GH14784@duo.random> <Pine.LNX.4.64.0804062246030.18148@schroedinger.engr.sgi.com>
 <20080407060602.GE9309@duo.random> <Pine.LNX.4.64.0804062314080.18728@schroedinger.engr.sgi.com>
 <20080407071330.GH9309@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It may also be useful to allow invalidate_start() to fail in some contexts 
(try_to_unmap f.e., maybe if a certain flag is passed). This may allow the 
device to get out of tight situations (pending I/O f.e. or time out if 
there is no response for network communications). But then that 
complicates the API.

