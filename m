Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbYI1Rvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbYI1Rvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 13:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYI1Rvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 13:51:31 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33698 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYI1Rva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 13:51:30 -0400
Message-ID: <33521.166.70.238.43.1222622153.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 28 Sep 2008 11:15:53 -0600 (MDT)
Subject: [REQUEST] Clarification from Copyright Holders on FUSE/NDISWRAPPER
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have been involved in numerous discussions with a variety of folks,
including Bruce Perens regarding the new policy governing kernel drivers
created for specific hardware/features and the Linux Foundations position
on proprietary hardware drives.  I have attempted to contact the FSF and
discuss this with them and they have refused to respond to letters or
return telephone calls to discuss this topic (I do not believe this is the
result of malice on their part or some conspiracy -- I think its just too
complex a question for them to address at the present time).

The consensus opinion from Bruce and others seems to be that applications
that use normal system services on Linux do not appear to be involved in
GPL related issues.  Additionally, there seems to be agreement that end
users (i.e. consumers) who are the targeted end point of distribution are
not under any GPL restraints provided they are not involved in
distribution.  In other words, someone who downloads Linux then downloads
a custom binary driver and combines the two pieces for their own use is
not constrained by the GPL since if it did place constraints on consumer
use, it would violate the Latham Act and other anti-trust laws since it
would be targeting consumers with restrictive covenants and price fixing.

THE QUESTION

I have carefully examined FUSE and file system drivers and this appears to
meet the definition of user space derived applications also unconcerned
with the GPL.  I need to know if this is the understanding of the actual
copyright holders of Linux regarding FUSE or if FUSE is considered a user
space application or if it is considered a part of the kernel.

Our analysis indicates separately distributed binary drivers are not
concerned with the GPL provided they are not distributed with Linux or
derived from it (I have a hard time understanding how a driver written for
a kernel OS cannot be considered "derived" from Linux, but apparently it
is not provided it uses none of the Linux code or includes -- ndiswrapper
is a great example of this).

At present, I compile file system drivers as Windows executables (*.sys)
and I load them with a modified version of ndiswrapper if I need to use
them in Linux.   I would like to move to FUSE for several customers who
wish to use Linux.

I would appreciate whomever owns the File System area to let me know their
view of this before I start moving the code over to FUSE.  My analysis to
date indicates that drivers compiled on Windows and loaded on Linux on an
ndiswrapper-like PE Loader shim that maps the VFS to an external binary
driver interface does not violate the GPL, particularly since the end
customers are actually the folks who install it on Linux and they do not
distribute it.

I apologize in advance for asking this question here since I have
attempted to talk to Bruce and others about it, and the FSF has gone deaf,
dumb, and silent and won't address it -- probably because without the
input of the copyright holders they have no answer.

Best Regard,

Jeff





