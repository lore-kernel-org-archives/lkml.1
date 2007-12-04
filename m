Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbXLDOiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbXLDOiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 09:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXLDOhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 09:37:25 -0500
Received: from cet.com.ru ([195.178.208.66]:55189 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXLDOhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:37:16 -0500
Cc: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [0/4] DST: Distributed storage.
In-Reply-To: <aqqqqasdzxczc036@2ka.mipt.ru>
X-Mailer: Patch sending script by Greg Kroah-Hartman
Date: Tue, 4 Dec 2007 17:37:06 +0300
Message-Id: <11967790263179@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Distributed storage.

I'm pleased to announce the 10'th release of the distributed
storage subsystem (DST). This is a maintenance release and includes
bug fixes and simple feature extensions only.

DST allows to form a storage on top of local and remote nodes
and combine them into linear or mirroring setup, which in
turn can be exported to remote nodes.

Short changelog:
 * fixed bug with XFS metadata update (it can provide slab pages to the
	DST, so it is not allowed to transfer them using ->sendpage())
 * fixed async error completion path
 * extended netlink communication channel to report errors back to userspace
 * DST name is now "The 10'th dynasty of smuggled slothes"
 * number of fixes for userspace DST target

Great thanks to Matthew Hodgson <matthew@mxtelecom.com> for debugging and
fixes for userspace DST target and preliminary netlink extension patches.

Overall list of features of the DST can be found on project's homepage:

http://tservice.net.ru/~s0mbre/old/?section=projects&item=dst

Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>


