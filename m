Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbYCDQjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbYCDQjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765725AbYCDQfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:35:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:28739 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765445AbYCDQfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MC/1mLxUu5JdHp56D8cGHsxtocOXk23W1+kNY7+vjuJbWgNPlCrA5Q7ZTCkpZiGW1WNs0zAhD6iL/q1tdyn8nqHJ4fF9OBR2rw7y4McXqrhNpc0+NktcPM+Z+5oc1x0F21fm6vvQraZP9yABlZaNsrwqyXRthESJNkfKZkuzFow=
Message-ID: <a67db0c60803040835g78a5476dkdcefcd66fc696527@mail.gmail.com>
Date: Tue, 4 Mar 2008 11:35:46 -0500
From: "R H" <robheilman@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: March 2008: Current state of oops/crash dumps
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a lot of information on the web about Linux and oops/crash
dumps.  Some positive, some quite negative.  There are lots of pages
about tools, patches, best practices, etc.  The problem is that they
all seem to be out of date.  I think the latest patch I have seen
available was for 2.6.10.  All this data begs the question:

What is the current state and roadmap for Linux kernel oops/crash dump
capabilities?

I ask this because it has always been of interest, a "barb" from the
"true unix" zealots, and more importantly I have a machine or two that
keeps panicing.  While I know I can setup a serial output to capture
said oops, the hardware I am using is not very conducive to such a
setup in our environment.  (Blades requiring front side dongles in a
very tight cage provided by our colo)

The FAQ for this mailing list even states that x86 hardware is not
conducive to collecting crash dumps.  The FreeBSD camp seems to think
otherwise.  What are they doing that is so unique?  I spent some
midnight oil last night reading about their boot process.  While I am
certainly in a little deeper than my knowledge base, I didn't see
anything that seems groundbreaking in their boot/hardware management
process that should allow them to collect/dump data on a x86 platform
during a oops.  Am I missing something?

If this is covered somewhere please do whack me with a link or at
least a search phrase.  I have spent many hours both recently and over
the last couple years crawling the search engines with no real success
of which to speak.
