Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbYEGRIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbYEGRIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYEGRHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:07:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:41317 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYEGRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=e60KzzHDO+MCBPmb93fWTTAVPRu1Uret19k7EKn38fge4Q96dvsd3IOx3ckk3JLz5Sjv2+yHcT8rhpPd5qYlW2bHf0p9roU9Vadf67+nxEkJiv/GxRZ1RqAFT/JNoMT6l4Fq5Gh9i3Gm8xfGzWmtPVjbs4xlgEsITe9ZQZbbenE=
Message-ID: <1f1b08da0805071007t37d7db7fn40daaf2d17fba0f1@mail.gmail.com>
Date: Wed, 7 May 2008 10:07:49 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Martin Knoblauch" <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <177578.8968.qm@web32608.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <177578.8968.qm@web32608.mail.mud.yahoo.com>
X-Google-Sender-Auth: c48677243d3adf05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 5:42 AM, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> Hi,
>
>   any news on the one below? I upgraded to 2.6.25.2 and the problem still persists. Would adding a bugzilla actually help ? :-)
>
>
>  http://www.ussg.iu.edu/hypermail/linux/kernel/0804.2/1144.html

With this issue you're seeing is only the printk timestamps jumping
back, correct?

For example, you're not seeing the output from gettimeofday() or the
actual jiffies value (as seen from maybe a driver) jump backward? Is
that right?

The printk timestamps may jump around a bit at bootup,  especially if
you have unsynced TSCs, so that is a known issue. However its not
known to have any actual negative effect other then maybe causing the
dmesg log to be a bit confusing.

thanks
-john
