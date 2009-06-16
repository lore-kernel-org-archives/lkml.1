Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbZFPS0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbZFPS0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZFPS0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:26:05 -0400
Received: from vena.lwn.net ([206.168.112.25]:35284 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbZFPS0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:26:04 -0400
Date: Tue, 16 Jun 2009 12:26:03 -0600
From: Jake Edge <jake@lwn.net>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: problem with function_graph self-test?
Message-ID: <20090616122603.6a628097@chukar>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

This has taken me a bit to track down ... I built a kernel from Linus's
git tree (as of this morning: commit
03347e2592078a90df818670fddf97a33eec70fb) and when i boot it, it locks
up hard giving me a cursor in the upper left (which seems to grow then
shrink once, if that tells anyone anything) and no other output ... i
started messing with kernel params (turning off quiet, rhgb, adding
boot_delay and, eventually figuring out i needed lpj as well) to try
and extract some info ... it seems to reliably fail in the
function_graph tracer self-test with a variety of messages (I
unfortunately don't have a serial console on the laptop that I am
using) ... two of the messages that I got (possibly from different
boots):

BUG: unable to handle kernel NULL pointer dereference at 00000048
BUG: Function graph tracer hang!

I can try and get more information, but I wanted to check first if you
already know about this ... somehow i'll either need to type faster :)
or reliably slow it down and take pictures, which I can do if you'd
like ...

obviously, for my purposes, i can turn off the selftests and/or the
function_graph tracer ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
