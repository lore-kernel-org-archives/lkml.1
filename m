Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYLGSn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYLGSn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbYLGSnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:43:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:38742 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYLGSnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=mfab3oK/s/6mUM8e0yFODBU2vZ6syjNNXnc7x3CFOdQmyjSK+4dkOyNQAzr37dA0YX
         JNhifuQFxGh8+K3oJhhUpYJi0uvHBJUuMFPLjXCWchBw4ZgA1yaBOwV/uDwJEeCh3eFL
         UO0nHHkwfIlAJIeCXXwduF625pyeACoQy60ZE=
Date: Sun, 7 Dec 2008 19:43:16 +0100
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/4] ide: remove ide-scsi remnants
Message-ID: <20081207184316.GA30260@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 06:21:07PM +0100, Borislav Petkov wrote:
> Hi Bart,
> 
> here are the patches removing bits and pieces belonging to the late ide-scsi :).
> 

here's the correct (and not reversed :)) diffstat though:

 drivers/ide/ide-atapi.c  |   97 +++++++++-------------------------------------
 drivers/ide/ide-io.c     |    3 -
 drivers/ide/ide-ioctls.c |    3 +-
 drivers/ide/ide-probe.c  |    2 -
 include/linux/ide.h      |   34 ++++++----------
 5 files changed, 33 insertions(+), 106 deletions(-)

-- 
Regards/Gruss,
    Boris.
