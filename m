Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZDLBx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZDLBx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 21:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZDLBxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 21:53:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845AbZDLBxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 21:53:50 -0400
Date: Sat, 11 Apr 2009 18:50:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.28 /proc/diskstats
Message-Id: <20090411185055.cab6a069.akpm@linux-foundation.org>
In-Reply-To: <49E13D18.2090805@solemnwarning.net>
References: <49E13D18.2090805@solemnwarning.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009 02:00:08 +0100 Daniel Collins <solemnwarning@solemnwarning.no-ip.org> wrote:

> Hi
> 
> Since 2.6.28, fd0 isn't visible in /proc/diskstats from boot, only after 
> access/mount. It is visible in /sys/block/ from boot, so there are no 
> issues detecting it. This may also affect other devices such as hda but 
> I haven't tested this yet, my test system and QEMU both only have 
> ram0-ram15 from boot. I have tested 2.6.30-rc1 and found the same 
> behavior. Is this a bug or a deliberate change?
> 

Tejun touched it last :)
