Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXGIPuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXGIPuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbXGIPuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:50:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47599 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724AbXGIPup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:50:45 -0400
Date: Mon, 9 Jul 2007 08:50:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mbligh@google.com
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality,
 performance and maintenance
In-Reply-To: <p73y7hrywel.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <p73y7hrywel.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Andi Kleen wrote:

> Christoph Lameter <clameter@sgi.com> writes:
> 
> > A cmpxchg is less costly than interrupt enabe/disable
> 
> That sounds wrong.

Martin Bligh was able to significantly increase his LTTng performance 
by using cmpxchg. See his article in the 2007 proceedings of the OLS 
Volume 1, page 39.

His numbers were:

interrupts enable disable : 210.6ns
local cmpxchg             : 9.0ns
