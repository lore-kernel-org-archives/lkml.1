Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYACQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYACQQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYACQQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:16:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:44721 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYACQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=v0uTwiRJm8GLPQtboA/jffj/aUkHQyu1osfmUvSNN7Z3i7XxYMOukKo3ygIywVSLg1ZWhkPTxpnESKOZZB0lE5UnhxIH6LguD/gYY7H7iQB7D+p6nuJCnWMfdG6X+PbVpuYm7jJZdIFGVHuWlh6D6Cykz0hABwJsxgzDf6pGaYg=
Message-ID: <d120d5000801030816o697219d8h664b2823e1965cfc@mail.gmail.com>
Date: Thu, 3 Jan 2008 11:16:02 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Richard Purdie" <rpurdie@rpsys.net>
Subject: Re: [PATCH] Fix spitzkbd suspend key handling
Cc: Linux-Input <linux-input@atrey.karlin.mff.cuni.cz>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1199233037.4653.44.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199233037.4653.44.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 1, 2008 7:17 PM, Richard Purdie <rpurdie@rpsys.net> wrote:
> The spitz keyboard driver reports KEY_SUSPEND events but doesn't
> register its use of this event in the keybit bitfield, breaking input
> events for this key. This patch fixes that by registering the key in the
> keybit bitfield.
>

Applied to my tree - for-linus branch. Thank you Richard.

-- 
Dmitry

P.S. Try to migrate to linux-input@vger, I'd like to get off atrey server
