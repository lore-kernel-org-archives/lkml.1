Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYIWOBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYIWOBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYIWN5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:57:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:38950 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbYIWN5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TiFCfSzz1cLKeoGZjISE+xp4GyXk1YA8qOQUVs/kIv2f9F514s2MAWuGfHy3ACklrd
         +Br1Dc6bUuB6Vc6nWObiHr+r6t/Z8ldbE4Je7K16dtklGJDHInFtfaZx0A5NAjdJS0pw
         kKXXpxyoS4ZIqxWIx5/rcvu8n0dX2PMzoF/JE=
Message-ID: <6278d2220809230657o33448333uf2e8fe421dd2244b@mail.gmail.com>
Date: Tue, 23 Sep 2008 14:57:35 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: tim.gardner@canonical.com
Subject: Re: Serious e1000e driver issue on Intrepid
Cc: ubuntu-devel@lists.ubuntu.com,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <48D8EC11.9010700@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D8EC11.9010700@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

[cross-posting to LKML]

On Tue, Sep 23, 2008 at 2:16 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Folks,
>
> There are beginning to be an increasing number of reports regarding a
> serious regression in Intrepid with regard to the e1000e ethernet driver
> wherein it can be rendered permanently inoperable. The original Bugzilla
> report is here:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=11382
>
> SuSE has also made an announcement regarding this issue:
>
> http://news.opensuse.org/2008/09/22/serious-e1000e-driver-issue-in-sle-11-beta-1-and-opensuse-111-beta-1
>
> Given the severity of this issue, I'm inclined to blacklist the driver
> by default in modutils until such time as Intel develops a fix.
>
> How do we inform users when their ethernet suddenly stops working after
> an update?

The 2.6.27-rc7 changelog shows this problem has been fixed for e1000:
http://www.kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.27-rc7

and this patch in the -mm series fixes it for e1000e:
http://marc.info/?l=linux-mm-commits&m=122038324200305&w=2

Clearly, we need to ensure the second patch makes it into 2.6.27
final; the corruption is reported to occur during suspend/resume
cycles.

Thanks,
  Daniel
-- 
Daniel J Blueman
