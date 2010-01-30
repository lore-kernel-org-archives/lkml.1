Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564Ab0A3H5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0A3H5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 02:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338Ab0A3H5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 02:57:08 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:42349 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0A3H5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 02:57:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ba/6w+rOBVD+3ddKQ5tlNWt+fEjFDW49X8fnZFA1ztCJRtdJsjWDshgo6815/iSa9o
         Fh9nBzmm/ONLqk1PVeXWU0PNhxDGQKJ2nNWqe5Ph/RVQ//ndtWc2Qqdrp5jgfm6k7GL4
         8FBWkgsLcLMsnAbi/+qNfc7Aw8D1O8VgtNdzg=
Date: Fri, 29 Jan 2010 23:57:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: remove BKL from uinput open function
Message-ID: <20100130075702.GC30378@core.coreip.homeip.net>
References: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 07:23:16PM -0200, Thadeu Lima de Souza Cascardo wrote:
> Commit 8702965848ed4bee27486a3e3d2ae34ebba6dd83 has push down the BKL
> into uinput open function. However, there's nothing that needs locking
> in there.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Applied to next, thank you.

-- 
Dmitry
