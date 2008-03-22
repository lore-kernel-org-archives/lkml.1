Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYCVPqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYCVPqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 11:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYCVPqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 11:46:16 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:59742 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYCVPqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 11:46:16 -0400
Date: Sat, 22 Mar 2008 16:45:59 +0100
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
       Adrian McMenamin <adrian@mcmen.demon.co.uk>
Subject: Re: [PATCH 5/5] cdrom: make unregister_cdrom() return void
Message-ID: <20080322154559.GA12505@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Adrian McMenamin <adrian@mcmen.demon.co.uk>
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C> <20080322031204.GC3665@APFDCB5C> <20080322031248.GD3665@APFDCB5C> <20080322031413.GE3665@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322031413.GE3665@APFDCB5C>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 12:14:14PM +0900, Akinobu Mita wrote:
> Now unregister_cdrom() always returns 0.
> Make it return void and update all callers that check the return value.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  Documentation/cdrom/cdrom-standard.tex |    2 +-
>  drivers/cdrom/cdrom.c                  |    3 +--
>  drivers/cdrom/gdrom.c                  |    4 +++-
>  drivers/cdrom/viocd.c                  |    5 +----
>  drivers/ide/ide-cd.c                   |    5 ++---
>  include/linux/cdrom.h                  |    2 +-
>  6 files changed, 9 insertions(+), 12 deletions(-)

Acked-by: Borislav Petkov <petkovbb@gmail.com>
