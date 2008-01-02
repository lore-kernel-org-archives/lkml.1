Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbYABVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbYABVEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYABVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:04:25 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52324 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751927AbYABVEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:04:25 -0500
Date: Wed, 2 Jan 2008 13:04:23 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Travis <travis@sgi.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/10] x86_64: Use generic percpu
In-Reply-To: <20080101191758.GA14045@elte.hu>
Message-ID: <Pine.LNX.4.64.0801021302530.22538@schroedinger.engr.sgi.com>
References: <20071228001046.854702000@sgi.com> <20071228001047.556634000@sgi.com>
 <200712281354.52453.ak@suse.de> <47757311.5050503@sgi.com>
 <20071230141829.GA28415@elte.hu> <477916ED.8010602@sgi.com> <47792295.8070001@sgi.com>
 <20080101191758.GA14045@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008, Ingo Molnar wrote:

> FYI, i tried your patchset on 2.6.24-rc6+x86.git, and randconfig testing 
> found a faulty 32-bit config below - the bootup would spontaneously 
> reboot shortly after hitting user-space. (which suggests a triple fault) 
> No log messages on the serial console.

The triple fault does not occur without the patchset?
