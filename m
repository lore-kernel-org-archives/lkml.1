Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0BESOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:14:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab0BESOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:14:36 -0500
Date: Fri, 5 Feb 2010 19:14:13 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, balbir@linux.vnet.ibm.com,
       jdike@addtoit.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
Message-ID: <20100205181413.GV5959@random.random>
References: <20100203161103.11e2b572@annuminas.surriel.com>
 <20100204041212.GI19641@balbir.in.ibm.com>
 <4B6ACE5B.9080601@redhat.com>
 <20100204174715.GL5959@random.random>
 <20100205173422.GA14706@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205173422.GA14706@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 03:34:23PM -0200, Marcelo Tosatti wrote:
> But perhaps a module parameter to turn accessed bit emulation off might
> be handy in the future?

Maybe, but somebody should show that this can overall become a
downside, which I doubt... I think if it does, the VM is to blame for
calling page_referenced when there is no point to do so just yet.
