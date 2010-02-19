Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0BSJjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 04:39:36 -0500
Received: from www84.your-server.de ([213.133.104.84]:34938 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0BSJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 04:39:28 -0500
Subject: Enhanced reimplemention of the kfifo API request for merge
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <1265961158.32651.9.camel@wall-e>
References: <1265961158.32651.9.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 19 Feb 2010 10:39:16 +0100
Message-ID: <1266572356.10556.13.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there a change to get the new generic kfifo API merged into the
linux-next, mm- or the upcoming 2.6.34 tree?

All features and complains are implemented. I got a lot of commits and
positve feedback but no ack's.

So the question is should i continue to work?

If i get an okay for the merge, the next steps will be:

- add a short HOWTO file into the Documentation directory
- replace all kfifo_out_locked() into kfifo_out_spinlocked() and
  replace all kfifo_in_locked() into kfifo_in_spinlocked()
- modify the drivers to use the type based FIFO
- maybe port drivers which use its own fifo implementation to the new
  kfifo API

Stefani ;-)


