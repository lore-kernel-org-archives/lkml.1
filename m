Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYDBRrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYDBRrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYDBRrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:47:11 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51121 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755031AbYDBRrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:47:10 -0400
Date: Wed, 2 Apr 2008 10:44:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Hugh Dickins <hugh@veritas.com>,
       Andrea Arcangeli <andrea@qumranet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/9] EMM Notifier: The notifier calls
In-Reply-To: <20080401213811.GD8558@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0804021044180.27214@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <1207084480.29991.2.camel@lappy> <20080401213811.GD8558@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Paul E. McKenney wrote:

> Peter has it right.  You need to rcu_dereference() the same thing that
> you rcu_assign_pointer() to.

Ah. Ok. Thanks.

