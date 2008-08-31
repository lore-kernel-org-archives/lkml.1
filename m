Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYHaQLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYHaQLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYHaQLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:11:10 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:35131 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYHaQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gcMJm5AqX3jElFJlp7Z/ZOIH//A+cNocqHgg07ZvM2+aEzm/WaSwlqaE4Fzl96evED
         vjHcRfVy20iJcwGyzY7DduAEiwWE9DGXvKFkaN5gYRQ9ZgghYo57wtf27sC0Nd14tu6E
         6tS1ParGIRCntBN8o79V3Oi3FEsXo7SPaGGkE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] ide: Build fix for CONFIG_IDE_PROC_FS=n
Date: Sun, 31 Aug 2008 17:52:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080829213217.4826.91622.stgit@denkblock.local>
In-Reply-To: <20080829213217.4826.91622.stgit@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311752.06818.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Elias Oltmanns wrote:
> Recent changes have broken compilation when CONFIG_IDE_PROC_FS is not set.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

Thanks!

I integrated your fixes into guilty patches ("ide-floppy: move /proc handling
to ide-floppy_proc.c" and "ide-disk: move /proc handling to ide-disk_proc.c")
to preserve bisection.
