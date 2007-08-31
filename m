Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbXHaPfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbXHaPfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbXHaPfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:35:09 -0400
Received: from max.aladin.ro ([80.96.155.2]:34348 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819AbXHaPfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:35:08 -0400
Message-ID: <46D83528.8090204@aladin.ro>
Date: Fri, 31 Aug 2007 18:35:04 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Forced unmounting for removable devices
References: <46D622A5.2000205@aladin.ro>
In-Reply-To: <46D622A5.2000205@aladin.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Salah Coronya wrote:
> There are patches in -mm for revokeat()/frevoke(), which can be used to
> implement exactly that. If a device "vanishes" (CD is removed in the
> middle of loading, USB pend rive yanked out the middle of I/O, NFS
> server thats gone MIA), A user-space program (maybe HAL) could iterate
> over the open files and revoke() them, at which point the system can be
> cleanly unmounted.
> 

Sounds promising. Is there any glibc version that implements these 
syscalls (googling for 'glibc' and 'frevoke' didn't help)? I'd like to 
implement and test this on my Linux box with HAL.
