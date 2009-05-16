Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZEPUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZEPUKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZEPUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 16:10:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48484 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZEPUKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 16:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=numWpTZIYYK/Xl640XN6FwDBJ5yYHL2XX2CKHkZslbjoP2n38XAUx5CX/Sja7nZsP7
         AUyQULUcGJunSqoowwXQMIvBqTVrmsQGRgHrVQPVPkVtzYNIb0hswEpzibo3aFYLH/m+
         Y1f3cUQ68CWULDXHQKUnsQGQvWolm/3IR131o=
MIME-Version: 1.0
In-Reply-To: <1241620755-22133-2-git-send-email-nigel@tuxonice.net>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <1241620755-22133-2-git-send-email-nigel@tuxonice.net>
Date: Sat, 16 May 2009 22:10:04 +0200
Message-ID: <19f34abd0905161310va93c499h158f3d7d5e687313@mail.gmail.com>
Subject: Re: [PATCH 1/19] TuxOnIce: Documentation
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a very small comment below.

2009/5/6 Nigel Cunningham <nigel@tuxonice.net>:
> This patch creates new Documentation/power files for describing
> TuxOnIce, and a MAINTAINERS entry for the code.
>
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> ---
>  Documentation/power/tuxonice-internals.txt |  477 ++++++++++++++
>  Documentation/power/tuxonice.txt           |  924 ++++++++++++++++++++++++++++
>  MAINTAINERS                                |    7 +
>  3 files changed, 1408 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/power/tuxonice-internals.txt
>  create mode 100644 Documentation/power/tuxonice.txt

[...]

> +   Most people will only want to hibernate to a local file. To achieve that, do
> +   something along the lines of:
> +
> +   echo "TuxOnIce" > /hibernation-file
> +   dd if=/dev/zero bs=1M count=512 >> hibernation-file

It seems that a / is missing here?

> +
> +   This will create a 512MB file called /hibernation-file. To get TuxOnIce to use
> +   it:
> +
> +   echo /hibernation-file > /sys/power/tuxonice/file/target


Vegard
