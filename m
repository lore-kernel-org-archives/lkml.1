Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYLGOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYLGOBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 09:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYLGOBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 09:01:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:45211 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYLGOBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 09:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=a5ekkkzku6ty9CaAO8ZouE8HN+rLumU11cnf2A6sm/MkLDtb9h8zFX+GtrAyutrEV4
         iRfLewjKGSiXRQfMgHGX8DVRP/oaOYV+FvLwlEeuktzieRDdh8JbJ7CkRLIbNxxPs1k1
         MoP+mUGo3usKitpeczmRR6muDmRdUTI91zQLE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 5/6] ide-cd: move cdrom_timer_expiry to ide-atapi.c
Date: Sun, 7 Dec 2008 14:56:39 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com> <200812061551.24745.bzolnier@gmail.com> <20081206200316.GB13838@gollum.tnic>
In-Reply-To: <20081206200316.GB13838@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812071456.39288.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008, Borislav Petkov wrote:

> here is a v2:
> ---
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Sat, 6 Dec 2008 20:08:35 +0100
> Subject: [PATCH] ide-cd: move cdrom_timer_expiry to ide-atapi.c
> 
> - cdrom_timer_expiry -> ide_cd_expiry
> - remove expiry-arg to ide_issue_pc as it is redundant now
> - ide_debug_log -> debug_log
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied, thanks
