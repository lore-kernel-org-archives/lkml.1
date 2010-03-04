Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0CDWF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:05:58 -0500
Received: from lucidpixels.com ([75.144.35.66]:42462 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0CDWF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:05:57 -0500
Date: Thu, 4 Mar 2010 17:05:56 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-ext4@vger.kernel.org
Subject: dump/restore not supported for ext4
Message-ID: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I should have researched it more:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511651
https://lists.ubuntu.com/archives/universe-bugs/2009-June/098729.html

Looks like it's broken, I agree with the reporters, dump should abort if 
it is dealing with an ext4 filesystem, since you cannot restore data from 
an ext4 dump.

Justin.
