Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbXIQRzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbXIQRzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXIQRzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:55:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41928 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbXIQRzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:55:00 -0400
Date: Mon, 17 Sep 2007 10:54:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configurable reclaim batch size
In-Reply-To: <1189812002.5826.31.camel@lappy>
Message-ID: <Pine.LNX.4.64.0709171053040.26860@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0709141519230.14894@schroedinger.engr.sgi.com>
 <1189812002.5826.31.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007, Peter Zijlstra wrote:

> It increases the lock hold times though. Otoh it might work out with the
> lock placement.

Yeah may be good for NUMA.
 
> Do you have any numbers that show this is worthwhile?

Tried to run AIM7 but the improvements are in the noise. I need a tests 
that really does large memory allocation and stresses the LRU. I could 
code something up but then Lee's patch addresses some of the same issues.
Is there any standard test that shows LRU handling regressions?

