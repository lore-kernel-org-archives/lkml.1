Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab0BGTW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 14:22:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005Ab0BGTW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 14:22:26 -0500
Date: Sun, 7 Feb 2010 17:21:01 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, balbir@linux.vnet.ibm.com,
       jdike@addtoit.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
Message-ID: <20100207192101.GB3387@amt.cnet>
References: <20100203161103.11e2b572@annuminas.surriel.com>
 <20100204041212.GI19641@balbir.in.ibm.com>
 <4B6ACE5B.9080601@redhat.com>
 <20100204174715.GL5959@random.random>
 <20100205173422.GA14706@amt.cnet>
 <20100205181413.GV5959@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205181413.GV5959@random.random>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 07:14:13PM +0100, Andrea Arcangeli wrote:
> On Fri, Feb 05, 2010 at 03:34:23PM -0200, Marcelo Tosatti wrote:
> > But perhaps a module parameter to turn accessed bit emulation off might
> > be handy in the future?
> 
> Maybe, but somebody should show that this can overall become a
> downside, which I doubt... I think if it does, the VM is to blame for
> calling page_referenced when there is no point to do so just yet.

Agreed. ACK.

