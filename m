Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbXHNR2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbXHNR2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759604AbXHNR1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:27:55 -0400
Received: from shakespeare.ccsl.carleton.ca ([134.117.225.11]:32908 "EHLO
	shakespeare.ccsl.carleton.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766004AbXHNR1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:27:52 -0400
Message-ID: <46C1E5F5.9050702@ccsl.carleton.ca>
Date: Tue, 14 Aug 2007 13:27:17 -0400
From: Hajime Inoue <hinoue@ccsl.carleton.ca>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca> <20070814000956.7c8929dd@the-village.bc.nu>
In-Reply-To: <20070814000956.7c8929dd@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments.

Alan Cox wrote:
 > This is to protect it from being changed by an attacker or someone trying
 > to do strange and bogus things to the kernel.
 >
 > What are you actually trying to achieve ?

I am trying to emulate an attacker.  I'm helping develop a system that
that detects stealthy malware.  To that end, we need to test the system in
an environment we completely understand.

Just protecting the table does not stop rootkits.  A highly referenced
phrack article explains how to bypass the table.  Enyelkm and mood-nt
are both compatible with a protected system call table (I tested them
against the latest Fedora stock kernel).  I'm trying to simulate a
rootkit less capable then those publicly available.

Why isn't the rest of the kernel code protected along with the table?
Your response leads to the inverse of my question.  How would I protect
the system call table (and other areas) in systems, without recompiling,
that do not protect them?

Finally, system call interposition is used in several interesting
systems, most notably, systrace.  It's unclear to me how one would
implement something like systrace without modifying the table or doing
other rootkit-like antics.

If anyone has problems explaining this publicly, please contact me
privately.  If anyone doubts my motivation, read my home page
(http://www.ccsl.carleton.ca/~hinoue/), or google my name.

-Hajime Inoue

