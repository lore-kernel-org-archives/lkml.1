Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbXLJLsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbXLJLsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbXLJLrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:47:42 -0500
Received: from tservice.ru ([195.178.208.66]:55434 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbXLJLrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:47:41 -0500
Cc: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [0/4] DST: Distributed storage.
In-Reply-To: <11qqqasdzxczc036@2ka.mipt.ru>
X-Mailer: Patch sending script by Greg Kroah-Hartman
Date: Mon, 10 Dec 2007 14:47:29 +0300
Message-Id: <11972872493977@2ka.mipt.ru>
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

I'm pleased to announce the 11'th release of the distributed
storage subsystem (DST). This is a maintenance release and includes
bug fixes and simple feature extensions only.

DST allows to form a storage on top of local and remote nodes
and combine them into linear or mirroring setup, which in
turn can be exported to remote nodes.

Short changelog:
 * wakeup state when mirror detected error to seedup reconnect
 * if connecting in csum mode to no-csum server, do not enable csums
 * do not clean queue until all users are removed
 * allow to increase size of the storage in linear add callback 
	(with this change it is possible to add nodes into linear array
	in real time without stopping storage. Filesystem has to be prepared
	for the case when underlying device has changed its size.
	Real-time addon of mirror nodes is also supported)
 * allow to delete gendisk only after device was started
 * dst debug config option
 * Name: Gamardjoba, genacvale! ('Hi friend' in georgian)

Great thanks to Matthew Hodgson <matthew@mxtelecom.com> for debugging!

Overall list of features of the DST can be found on project's homepage:

http://tservice.net.ru/~s0mbre/old/?section=projects&item=dst

Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>


