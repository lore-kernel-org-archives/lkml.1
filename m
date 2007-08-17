Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbXHQUnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbXHQUnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbXHQUnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:43:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754544AbXHQUnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:43:22 -0400
Date: Fri, 17 Aug 2007 13:43:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Satyam Sharma <satyam@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <20070817112253.e6a7cb33.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708171342190.9404@schroedinger.engr.sgi.com>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Andrew Morton wrote:

> are we seeing a pattern here?  We could stick the unlikely inside
> ZERO_OR_NULL_PTR() itself.  That's a little bit sleazy though - there might
> be future callsites at which it is likely, who knows?

Thought about that myself but then there would be a weird side effect to 
ZERO_OR_NULL_PTR(). But since your thinking along the same lines: Lets do 
it. I will fix up the patch to do just that.

