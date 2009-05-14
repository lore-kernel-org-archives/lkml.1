Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZENUC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZENUC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZENUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:02:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39423 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753463AbZENUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:02:16 -0400
Date: Thu, 14 May 2009 16:02:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 00/12] Hardware Breakpoint interfaces
In-Reply-To: <20090513161201.GA13911@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0905141555310.4344-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, K.Prasad wrote:

> Hi Alan,
> 	Please find a new set of patches with the following changes.
> I am eager to know if you think that they are ready for submission towards
> upstream acceptance.

This is looking pretty good.  Only one thing caught my eye: 
switch_to_thread_hw_breakpoint and switch_to_none_hw_breakpoint do 
nothing but call the corresponding arch-specific routines.  You might 
as well eliminate them and have the callers invoke the arch-specific 
routines instead.

Alan Stern

