Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYCaR0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYCaR0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYCaR0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:26:33 -0400
Received: from baikonur.stro.at ([213.239.196.228]:39729 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYCaR0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:26:32 -0400
Date: Mon, 31 Mar 2008 19:24:55 +0200
From: maximilian attems <max@stro.at>
To: Didier Raboud <didier@raboud.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org
Subject: Re: =?iso-8859-1?B?Mi42LjI1LXJjN6A6IGhp?=
	=?iso-8859-1?Q?bernation?= sometimes not resuming on Dell Latitude D630
Message-ID: <20080331172455.GV17874@baikonur.stro.at>
References: <200803311823.36693.didier@raboud.com> <200803311833.19730.rjw@sisk.pl> <200803311903.16011.didier@raboud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803311903.16011.didier@raboud.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 07:03:13PM +0200, Didier Raboud wrote:
<snipp>
> > > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two successful
> > > hibernate/resume cycles.
> >
> > Could you please check if the problem is still present if you boot with
> > acpi_new_pts_ordering kernel command line argument?
> 
> By the way, I just added acp_new_pts_ordering at the end of the Grub line 
> beginning by "linux (hd0,1)/vmlinuz(...)". Is that correct ?

seems strange you should add it to the kopt line and then kick as root
update-grub

# kopt=root=/dev/sda1 ro
it should land 
kernel          /boot/vmlinuz-2.6.25-rc7-amd64 root=/dev/sda1 ro
