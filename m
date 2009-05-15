Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbZEOAcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbZEOAcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 20:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZEOAcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 20:32:43 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:7242 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZEOAcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 20:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <1242338523.6933.664.camel@timo-desktop>
References: <1242338523.6933.664.camel@timo-desktop>
Date: Thu, 14 May 2009 20:32:43 -0400
Message-ID: <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com>
Subject: Re: ext3/ext4 directories don't shrink after deleting lots of files
From: Josef Bacik <josef@toxicpanda.com>
To: Timo Sirainen <tss@iki.fi>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 6:02 PM, Timo Sirainen <tss@iki.fi> wrote:
> I've noticed that if you create e.g. 100k files to a directory and then
> delete the files, the directory entry still seems to take a couple of
> megabytes. Later whenever accessing the (almost empty) directory it can
> take a few seconds to load it into cache.
>
> Is there a way to shrink the directory somehow without having to rmdir()
> it? Would be nice if kernel did it automatically, but I could live with
> a manual userspace syscall/tool as well.
>

fsck -D <device>, when its unmounted of course.

Josef
