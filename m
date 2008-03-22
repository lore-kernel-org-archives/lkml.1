Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYCVM5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYCVM5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 08:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYCVM5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 08:57:22 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17375 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYCVM5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 08:57:21 -0400
Date: Sat, 22 Mar 2008 13:57:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Adrian McMenamin <adrian@mcmen.demon.co.uk>,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 5/5] cdrom: make unregister_cdrom() return void
Message-ID: <20080322125711.GG15355@kernel.dk>
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C> <20080322031204.GC3665@APFDCB5C> <20080322031248.GD3665@APFDCB5C> <20080322031413.GE3665@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322031413.GE3665@APFDCB5C>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22 2008, Akinobu Mita wrote:
> Now unregister_cdrom() always returns 0.
> Make it return void and update all callers that check the return value.

Patches 1-3 and 5 are fine, thanks. If you can rediff #4 with the list
init part added, it's good to go.

-- 
Jens Axboe

