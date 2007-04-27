Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbXD0Sgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbXD0Sgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbXD0Sgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:36:31 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:42656 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012AbXD0Sga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=bNp4Q9yOr8XGdjza8GMyOl1GzCZQdZHFkFpOwGwEz4EfNSeITZXhMsX2cegNWiouNH/Y7YmWlLAdEFrjFVK2zw8fN1DwTYjFbx5S+Ez4CMHfAaJ0Tl0SrpVnfsDFeeGklcRZoNsaUG3L9tLIZWFylp3Fc1K4cKu+e+DpPJXzfH8=
Message-ID: <463242AC.5050608@gmail.com>
Date: Fri, 27 Apr 2007 21:36:28 +0300
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <20070427165544.99355.qmail@web36709.mail.mud.yahoo.com>
In-Reply-To: <20070427165544.99355.qmail@web36709.mail.mud.yahoo.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> In general, it is impossible to maintain out-of-tree driver in sync with kernel tree - too many
> changes are committed into it. The -mm version obviously fits its tree.
>
I have compiled v2.6.21 with git-mmc.patch of v2.6.21-rc7.mm2.
After [tifm_sd] is loaded. My smoke test script at

http://bugzilla.kernel.org/attachment.cgi?id=11240&action=view

reliably hangs suspend.

I didn't even see a failure for 'modprove -r tifm', which
doesn't exist in this build.

I will try to bisect git-mmc.patch to locate the source of
trouble. And I will compile my version to check it against
-mm tree.
