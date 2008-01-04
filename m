Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYADNUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYADNUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYADNUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:20:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYADNUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:20:39 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [1/16] Make clocksource watchdog cycle through online CPUs
Date: Fri, 4 Jan 2008 13:59:56 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <20080103154214.B618F14DDB@wotan.suse.de> <20080104085124.GA28740@elte.hu>
In-Reply-To: <20080104085124.GA28740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801041359.56968.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 09:51:24 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > This way it checks if the clocks are synchronized between CPUs too. 
> > This might be able to detect slowly drifting TSCs which only go wrong 
> > over longer time.
> 
> ok, makes sense - applied. Have you seen this trigger in practice?

No, obviously because there are no per CPU timers currently.

-Andi


