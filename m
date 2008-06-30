Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbYF3VGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbYF3VGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYF3VGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:06:43 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:16579 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbYF3VGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fzAm4mrbghkYor5FxaubzRAH6sfjQivBdyvN3WaqiT74De4LGtcd2TjM8Tn4c5V440
         PLU0wJxNwnmwbxUct4Ayg/0G8hRNqENk2hGVK8BrTP/7mjVd7tPdGOupUg0fdmJAQIsH
         r9Z2jijGQoYtuZMu+brQjP1pA3GJhXUg4wAT0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 00/16] Generic ide device flags
Date: Mon, 30 Jun 2008 22:44:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806302244.52788.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 29 June 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's another series of generic ide tweaks. The biggest change in here is the
> introduction of ide_drive_t->dev_flags member which replaces all flags members
> in the drivers structs. As a result, some PC_FLAGs become useless and got
> removed, details in the respective patch descriptions below. The changes have
> been tested with the hardware i have (i.e., ide-cd and ide-floppy).

Thanks, I applied everything.

[ I made two minor changes while at it: HWGROUP(drive) is on its way out so
  was replaced by 'hwif->hwgroup' and IDE_FLAG_* were renamed to IDE_DFLAG_*
  for consistency (we already have IDE_HFLAG_* and IDE_TFLAG_*). ]

Bart
