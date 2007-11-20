Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbXKTCNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbXKTCNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760627AbXKTCAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:00:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50700 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760480AbXKTCAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:00:41 -0500
Message-ID: <47423FB7.20800@zytor.com>
Date: Mon, 19 Nov 2007 18:00:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 37/45] x86_64: Support for fast per cpu operations
References: <20071120011132.143632442@sgi.com> <20071120011340.569486037@sgi.com>
In-Reply-To: <20071120011340.569486037@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Support fast cpu ops in x86_64 by providing a series of functions that
> generate the proper instructions. Define CONFIG_FAST_CPU_OPS so that core code
> can exploit the availability of fast per cpu operations.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

There was, at some point, discussion about using the gcc TLS mechanism, 
which should permit even better code to be generated.  Unfortunately, it 
would require gcc to be able to reference %gs instead of %fs (and vice 
versa for i386), which I don't think is available in anything except 
maybe the most cutting-edge version of gcc.

However, if we're doing a masssive revampt it would be good to get an 
idea of how to migrate to that model eventually, or why it doesn't make 
sense at all.

	-hpa
