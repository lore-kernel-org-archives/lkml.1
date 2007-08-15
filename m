Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbXHOATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbXHOATn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXHOATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:19:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56610 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752926AbXHOATe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:19:34 -0400
Date: Tue, 14 Aug 2007 17:19:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Satyam Sharma <satyam@infradead.org>
cc: Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0708141716020.937@schroedinger.engr.sgi.com>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Satyam Sharma wrote:

> [PATCH] {slub, slob}: use unlikely() for kfree(ZERO_OR_NULL_PTR) check

Good that actually has a code impact.

