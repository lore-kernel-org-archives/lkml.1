Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZJETm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZJETm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZJETmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:42:55 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:39890 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbZJETmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:42:55 -0400
Message-ID: <4ACA4C11.9060107@wpkg.org>
Date: Mon, 05 Oct 2009 21:42:09 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Heh.  You've really squeezed yourself into a bad situation.  Go get a
> 64-bit kernel... please.  You should be able to run 32-bit userspace
> with a 64-bit kernel.  Do you have some 32-bit kernel component that you
> are relying on?

Note that in such setups (64 bit kernels and 32 bit userspace) *some* 
software will not work correctly (perhaps it's limited to tightly 
kernel-userspace integrated software).

One example is open-iscsi - you won't run 32 bit open-iscsi userspace on 
a 64 bit kernel (at least it was impossible a couple of months ago).


-- 
Tomasz Chmielewski
http://wpkg.org
