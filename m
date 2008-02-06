Return-Path: <linux-kernel-owner+w=401wt.eu-S1763866AbYBFCBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763866AbYBFCBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbYBFCA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:00:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:25624 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871AbYBFCAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:00:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uUSQjcaQmrXn2PZEwgxG1S6ANoj2LD7c0j6AQ23XRXAcX32BQFvn8Xf0s860K5VmNEOZe7JDEP4PCSTvTnWq9+YJnggi90yQpfjMHIG3Kl2Uyj4hLPLHuUGh3Oe7bui5W2BY5Zu9b89IiRTvbjH2zEUxr3mRpxjHYJHf0gHMH/U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Denis Cheng <crquan@gmail.com>
Subject: Re: [PATCH] ide-pci-generic: kill the unused ifdef/endif/MODULE code
Date: Wed, 6 Feb 2008 02:47:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1201942356-26897-1-git-send-email-crquan@gmail.com>
In-Reply-To: <1201942356-26897-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060248.00319.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Denis Cheng wrote:
> with module_param macro, the __setup code can be killed now:
> 	const __setup("all-generic-ide", ide_generic_all_on);
> 
> and the module name "generic.ko" is not descriptive to its functionality,
> can be changed in Makefile, the "ide-pci-generic.ko" is better.
> 
> the ide-pci-generic.all-generic-ide parameter also documented
> in Documentation/kernel-parameters.txt
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

applied, thanks

PS the other patch will take same more time to review
