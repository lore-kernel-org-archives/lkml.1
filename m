Return-Path: <linux-kernel-owner+w=401wt.eu-S1750905AbXBWFas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbXBWFas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 00:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXBWFas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 00:30:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbXBWFar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 00:30:47 -0500
Date: Thu, 22 Feb 2007 21:29:19 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org
Subject: input.c: start on release
Message-Id: <20070222212919.850ceafe.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a curious code I found in drivers/input/input.c (2.6.21-rc1):

void input_release_device(struct input_handle *handle)
{
....
	if (handle->handler->start)
		handle->handler->start(handle);
}

Is the above supposed to be this way, or you meant ->stop here?

The commit comment says:
	Input: fix list iteration in input_release_device()
It says me precisely nothing about the way it's supposed ot be, sorry...

-- Pete
