Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYHPU0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYHPU0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYHPUZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:25:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:33899 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYHPUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=gVNzlK9XeL6yj72Kd3SduHNS6+d4Nk64SgbirJVHFm+Q1mnmNPAqxM+dyy146BomOq
         Ar7RwST2sqbY2/nnURIhSaMC7J/oGpU8k/4D//kLlCNMoBiddEqpCQ01Yr2V1YA+MpUh
         fre8HXAHRtrK41M2PnHmnfn6Swi+FDfOeyrCc=
Date: Sat, 16 Aug 2008 22:26:00 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/18] ide-cd: cdrom_decode_status: factor out block pc
	error handling code
Message-ID: <20080816202600.GA13726@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <1213252870-20474-4-git-send-email-petkovbb@gmail.com> <200806141929.21329.bzolnier@gmail.com> <20080815073413.GA9906@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815073413.GA9906@gollum.tnic>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[.. ]

> here's a first attempt at that. These are only RFC of nature, please take a look
> when there's time. They've been lightly tested but I'll do more later since this
> path is not hit that often and a special test case will be required.

Yep, this one has problems as I just noticed. Reworking... 
