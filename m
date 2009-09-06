Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZIFSFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZIFSFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbZIFSFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:05:36 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56322 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbZIFSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qnR30jDUmAelExfAFQZ848yO6o7zM2s7dcVRdeVecPkmjuRIjUtDWQ7C0n/QMcC5BD
         B9zKbe+5xsexqmcrU+0e3nyB7oZkwpKpWeavxra7dtRRcl5yYodhGqhQjT3YhUWOelQE
         bRAAJdS8cB+F44ShCXoz9qcVUyux1m/A6bGrw=
Date: Sun, 6 Sep 2009 22:04:38 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       omegamoon@gmail.com, eric.miao@marvell.com, utx@penguin.cz,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: zaurus c3000 aka spitz: fix resume
Message-ID: <20090906180438.GA6835@doriath.ww600.siemens.net>
References: <20090906052840.GF1324@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090906052840.GF1324@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 07:28:40AM +0200, Pavel Machek wrote:
> 
> sharpsl_pm.c code tries to read battery state very early during
> resume, but those battery meters are connected on SPI and that's only
> resumed way later.
> 
> Replace the check with simple checking of battery fatal signal, that
> actually works at this stage.

Nice catch! Unfortunately I can't test the patch ATM, but it seems
resonable.

-- 
With best wishes
Dmitry

