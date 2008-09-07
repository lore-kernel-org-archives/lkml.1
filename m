Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbYIGS2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbYIGS2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 14:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbYIGS13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 14:27:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:43431 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYIGS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 14:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SytyIOHD3VfwO1/3viplfRSZGLxVjDRJe9hzrY8/djFgpJmwAxEmj+MW2GtmUuPNyK
         GdgXL9uO0Q3RFfTezI+0HVCPophiv5XNWBvl0t0NJyP249aOLV6sVAlV6/0HblLaZE7V
         boKjoiEDOZQXJh51c6LSePfG2oGfcAYNco+Hk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/2] ide-cd: convert driver to new ide debugging macro
Date: Sun, 7 Sep 2008 20:19:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1219496923-20868-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1219496923-20868-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809072019.52821.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2008, Borislav Petkov wrote:
> Also,
> 
> - leave in the possibility for optimizing away all debugging macros
> - add a PFX macro and prepend all printk calls with it for consistency
> - add debug macro calls in important driver paths
> - remove #if 0-ed code
> - mv restore_request -> ide_cd_restore_request
> - add a driver registration printk
> 
> There should be no functionality change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
