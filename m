Return-Path: <linux-kernel-owner+w=401wt.eu-S933738AbXGLNEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbXGLNEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760175AbXGLNEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:04:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:47196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760041AbXGLNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZczwpHwX3ncm79miasHLVc5DWa8oGaYriUygTiN5LE4/2BSmvorNQfCXAmgRQGV1evNUfP1CMW41qZd6aZmZvZhJjdhrbzYqc87QolcChdH5beST8NYRV+7Y+WE/BTCDrTKq3O0IU0t+5wZieTfY+0IBkpAown6j6ieO8qwZlwk=
Message-ID: <84144f020707120604v76768616o11de9395a4929214@mail.gmail.com>
Date: Thu, 12 Jul 2007 16:04:14 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Martijn Uffing" <mp3project@sarijopen.student.utwente.nl>
Subject: Re: RFH: Converting a driver from semaphore to mutex in 2.6.21
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0707121414540.17278@sarijopen.student.utwente.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.62.0707121414540.17278@sarijopen.student.utwente.nl>
X-Google-Sender-Auth: 1124052ea415f21a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/07, Martijn Uffing <mp3project@sarijopen.student.utwente.nl> wrote:
> I must miss something really really obvious, but I really can't find it.

[snip]

> drivers/i2c/chips/bt869.c:63: error: field `update_lock' has incomplete type

[snip]

> @@ -59,7 +60,7 @@ struct bt869_data {
>         struct i2c_client client;
>         int sysctl_id;
>
> -       struct semaphore update_lock;
> +       struct mutex_debug update_lock;
                      ^^^^^^

s/struct mutex_debug/struct mutex/g. Follow-ups to
http://kernelnewbies.org/ please.

                                           Pekka
