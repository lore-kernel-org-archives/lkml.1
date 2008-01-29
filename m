Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYA2Wcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYA2Wcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYA2Wch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:32:37 -0500
Received: from duempel.org ([78.31.71.42]:57261 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750882AbYA2Wcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:32:36 -0500
Date: Tue, 29 Jan 2008 23:32:35 +0100
From: Max Kellermann <max@duempel.org>
To: Rick Lindsley <ricklind@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1: oops in diskstats_show()
Message-ID: <20080129223234.GA8609@swift.blarg.de>
Mail-Followup-To: Rick Lindsley <ricklind@us.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20080125133250.GA12677@swift.blarg.de> <200801292222.m0TMMtEi024184@owlet.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801292222.m0TMMtEi024184@owlet.beaverton.ibm.com>
X-Terrorism: FBI NSA CIA Clinton Bush Blair Urane Nuclear Bomb Terror Hussein Iraq Iran Syria Plutonium Bin Laden World Trade Center Afghanistan Taliban Jaish Rocket Guantanamo Ziercke
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/01/29 23:22, Rick Lindsley <ricklind@us.ibm.com> wrote:
>     Right before the crash, I was torturing cryptsetup to experiment with
>     encryption - I created and deleted device mapper objects in a loop.
> 
> Creating and deleting block devices ... yeah, this is probably key to
> the problem. Can you provide the command or, more likely, script you
> were using to do this?

Hi Rick,

it was a very simple script, just the following two commands over and
over, nothing more:

  "cryptsetup create foo /dev/sdc6",
  "cryptsetup remove foo"

This is my workstation, I have been working at the same time (emacs,
gcc, ...), nothing special.

Max

