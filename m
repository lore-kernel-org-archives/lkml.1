Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbYEMRmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbYEMRmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbYEMRmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:42:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:18754 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYEMRmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vVnNc9t2ML5p9XgRGeZw2tpy+LSPzUB7ucHfGNe2x9yIBmiXaTrz4t3BoP932IO15tqXUBho1LnmVsSMijxEfPfAo1Z9VirpLhjxNSEzbtlbC5IW5u8C0UxpOG8waz6v2KiLGwFMUALIDUUUFPuqjMbA1CC9lUX/RMezQb63h2o=
Message-ID: <8bd0f97a0805131042x2a74115dqc3831a604583bbd5@mail.gmail.com>
Date: Tue, 13 May 2008 13:42:04 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH 1/1] [MTD/MAPS] Blackfin Async Flash Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Cc: linux-mtd@lists.infradead.org, "Bryan Wu" <cooloney@kernel.org>,
       dwmw2@infradead.org, will.newton@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080513153441.GB18026@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1210653525-19437-1-git-send-email-cooloney@kernel.org>
	 <20080513080727.GA15795@logfs.org>
	 <8bd0f97a0805130542x46f5e7fejf1347f1c71f567fb@mail.gmail.com>
	 <20080513150143.GA18026@logfs.org>
	 <8bd0f97a0805130815q2ffa1d34ue87f5eb1422b6f42@mail.gmail.com>
	 <20080513153441.GB18026@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:34 AM, Jörn Engel <joern@logfs.org> wrote:
> On Tue, 13 May 2008 12:38:45 +0800, Bryan Wu wrote:
> > +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
>
>  That bit is obvious.  But why do you use pr_devinit() instead of
>  printk()?  What does it gain you?

why do we have __init and __devinit in the first place ?
-mike
