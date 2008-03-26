Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYCZGne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYCZGne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYCZGn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:43:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbYCZGn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:43:26 -0400
Date: Tue, 25 Mar 2008 23:43:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: alex-lists-linux-kernel@yuriev.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Visible boot slowdown between 2.6.24.3 and 2.6.22.2
Message-Id: <20080325234323.77ebb46e.akpm@linux-foundation.org>
In-Reply-To: <20080326024829.GA20476@s1.yuriev.com>
References: <20080326024829.GA20476@s1.yuriev.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 22:48:29 -0400 alex-lists-linux-kernel@yuriev.com wrote:

> 	I saw a significant slowdown of a bootup time after 2.6.22.2 was
> upgraded to 2.6.24.3. Visibly I can see the issue when the boot process gets
> to running udev - now it sits for good minute or two. I can also visibly see
> a slowdown when I do "ps aux" under the new kernel vs. old one.
> 
> This is a relatively old system - 500 Mhz P3 Celeron with 512M RAM.
> 
> Any debugging suggestions are appreciated...

Could be the cpu frequency is wrong, could be that the MTRR system went wrong.

Please send the dmesg output for both 2.6.22.x and 2.6.24.x, as well as the
contents of /proc/mtrr for both kernels, thanks.

