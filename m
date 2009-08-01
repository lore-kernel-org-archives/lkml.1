Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbZHAMZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbZHAMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 08:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZHAMZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 08:25:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62387 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZHAMZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 08:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ly9FSZc4s+pw75xLuiuU4bUCtkszyvB39SsptWzTAZ8H+ORcknj3KjX5cCJYlGN0rc
         Vysf1+3LxO10JtaXEcoYtKe26qhg7ld4BcaSTNikIej7LAik423LdPYaePKNvcoHzAqo
         LkSEtf68yoVpr4xx8AxqnicdHUu2k1MC3++l8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908011052290.23408@ask.diku.dk>
References: <Pine.LNX.4.64.0908011052290.23408@ask.diku.dk>
Date: Sat, 1 Aug 2009 07:25:24 -0500
X-Google-Sender-Auth: 9e546eae125154d0
Message-ID: <ed82fe3e0908010525w56e93f6cl1d4c1bcc84d9e014@mail.gmail.com>
Subject: Re: [PATCH 1/10] arch/powerpc/sysdev/qe_lib: introduce missing kfree
From: Timur Tabi <timur@freescale.com>
To: Julia Lawall <julia@diku.dk>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 1, 2009 at 3:52 AM, Julia Lawall<julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Error handling code following a kzalloc should free the allocated data.
>

...

>
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  arch/powerpc/sysdev/qe_lib/qe_ic.c  |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

Acked-by: Timur Tabi <timur@freescale.com>

-- 
Timur Tabi
Linux kernel developer at Freescale
