Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZB0Iu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZB0Iu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZB0IuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:50:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35002 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZB0IuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:50:14 -0500
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: filesystem time stamp resolution
From: Andi Kleen <andi@firstfloor.org>
References: <49A7232C.6050808@redhat.com>
Date: Fri, 27 Feb 2009 09:48:23 +0100
In-Reply-To: <49A7232C.6050808@redhat.com> (Ulrich Drepper's message of "Thu, 26 Feb 2009 15:18:04 -0800")
Message-ID: <87r61k2rl4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper <drepper@redhat.com> writes:

> How can code at userlevel (e.g., glibc) determine the resolution of the
> a filesystem timestamp?

One issue is network file systems. The kernel has no idea what a
remote NFS (or other network) file system will support, because it
depends on the file system on the remote server.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
