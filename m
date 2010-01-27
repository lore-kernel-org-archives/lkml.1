Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276Ab0A0EJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0A0EJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 23:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089Ab0A0EJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 23:09:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35637 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0A0EJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 23:09:40 -0500
MIME-Version: 1.0
In-Reply-To: <20100126233922.430096741@mini.kroah.org>
References: <20100126233950.GA5372@kroah.com> <20100126233922.430096741@mini.kroah.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 27 Jan 2010 05:09:23 +0100
Message-ID: <ac3eb2511001262009o2bacb51n1acbaf64a526c0dc@mail.gmail.com>
Subject: Re: [12/98] Driver-Core: devtmpfs - set root directory mode to 0755
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mark Rosenstand <rosenstand@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 00:33, Greg KH <gregkh@suse.de> wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Kay Sievers <kay.sievers@vrfy.org>
>
> commit 03d673e6af6490371aaf64dfe1f84c658c48b71d upstream.

Hey Greg,
to silent a warning this change causes, this might also be good to have:
  vfs: get_sb_single() - do not pass options twice
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9329d1beaeed1a94f030c784dcec5ff973f402c4

Thanks,
Kay
