Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZI1LBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZI1LBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 07:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZI1LBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 07:01:54 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:52955 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZI1LBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 07:01:54 -0400
Message-ID: <4AC097A4.9070903@lumino.de>
Date: Mon, 28 Sep 2009 13:01:56 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
 energy
References: <20090923174820.GA12827@Krystal> <4ABA631A.8030306@nortel.com> <20090923190337.GA16983@Krystal> <20090923223204.GA2921@Krystal> <4ABAAB4F.2060905@nortel.com> <20090923232855.GB9621@Krystal> <4AC06187.2050806@lumino.de>
In-Reply-To: <4AC06187.2050806@lumino.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Schnell wrote:
> Why is that different ?

It might be that (different from a sema), a FUTEX can only be unlocked
by the process that locked it.

But then why should FUTEX offer advantages over sema, if in that
application the FUTEX is supposed to block with a system call, anyway ?

-Michael
