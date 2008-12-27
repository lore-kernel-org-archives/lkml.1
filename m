Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYL0Gkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYL0Gkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYL0Gkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:40:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:32689 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYL0Gko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:40:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NeXgpNrWlMjPpvYMSA6nxspR66rYRrOLPCNKMfqjPANhq1r4c4qojEtKuz6n9pFQ4B
         Xe8Z9r/iipeU5U2+Vun6GepKjgheIPkQ5BYP6+1IYsfGcA4lc1CORqBRjR+ieIozfUeJ
         uyS8QBlIV5GupCMieqNhkSFXVEzxLx3pSwxAo=
Message-ID: <8bd0f97a0812262240x46a0e197s7a46b19354c47aa9@mail.gmail.com>
Date: Sat, 27 Dec 2008 01:40:43 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] autodetect_raid: add missing __init marking
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1227240303-30591-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227240303-30591-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 23:05, Mike Frysinger wrote:
> The function autodetect_raid is only used by __init functions, and it refers
> to __initdata, so it needs __init markings.  Fixes this error:
> The function autodetect_raid() references
> the variable __initdata raid_noautodetect.
> This is often because autodetect_raid lacks a __initdata
> annotation or the annotation of raid_noautodetect is wrong.

Andrew: could you add this ?
-mike
