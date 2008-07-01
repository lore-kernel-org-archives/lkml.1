Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbYGADcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbYGADcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 23:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYGADcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 23:32:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbYGADco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 23:32:44 -0400
Date: Mon, 30 Jun 2008 20:32:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, bunk@kernel.org
Subject: Re: [PATCH 3/7] fat/dir.c: switch to struct __fat_dirent
Message-Id: <20080630203228.7b3ac420.akpm@linux-foundation.org>
In-Reply-To: <d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2008 11:57:03 +0900 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> struct __fat_dirent is what was formerly the kernel struct dirent
> (that was different from the userspace struct dirent).
> 
> Converting all fat users to struct __fat_dirent will allow us to get 
> rid of the conflicting struct dirent definition.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

I assume this was authored by Adrian.  Please tell me if that is wrong.

The way you sent this implies that you were the author.

The way to communicate authorship with emailed patches is to place the
author's "From:" line right at the top of the changelog.

Thanks.
