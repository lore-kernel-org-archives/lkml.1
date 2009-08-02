Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZHBPVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZHBPVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 11:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZHBPVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 11:21:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58166 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752367AbZHBPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 11:21:17 -0400
Date: Sun, 2 Aug 2009 11:21:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: linux-kernel@vger.kernel.org, <linux-fsdevel@vger.kernel.org>
Subject: Re: [review] fat/nls: Fix handling of utf8 invalid char
In-Reply-To: <87iqh7wddt.fsf@devron.myhome.or.jp>
Message-ID: <Pine.LNX.4.44L0.0908021117160.10433-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009, OGAWA Hirofumi wrote:

> Hi,
> 
> I'm going to send this patch at next merge window. This is including the
> change of fs/nls_base.c, it's trivial though. And it seems you changed
> the fs/nls_base.c last time.
> 
> So, to make sure, could you review this if you have time?
> 
> Thanks.

I don't know about the changes to namei_vfat.c, but the changes to 
nls_base.c look fine.  And since, as you say, VFAT is the only user of 
utf8s_to_utf16s(), it shouldn't cause any problems elsewhere.

Alan Stern

