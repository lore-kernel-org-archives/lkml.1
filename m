Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZINRt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZINRt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZINRtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:49:53 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:65230 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZINRtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MxZCfMn9ufWJGgE4jx4HK1xGx46uyHo06fPXSEtjZAZBm8YOR9iv7mX7FLGvqWoVIe
         QQ/oDJOiGKitwzT6kU9ToIg2DNeYMNJrtqQEnnEVc2SZ2KE10/pWXxlkKLBYOtbU3XJs
         W7qXMDkAAo4e1UZgDiy7k5h2frcLobl/Ev1g0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v3] input/keyboard: new OpenCores Keyboard Controller driver
Date: Mon, 14 Sep 2009 10:49:50 -0700
User-Agent: KMail/1.12.0 (Linux/2.6.31; KDE/4.3.0; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Javier Herrero <jherrero@hvsistemas.es>, Bryan Wu <cooloney@kernel.org>
References: <1252911864-19233-1-git-send-email-vapier@gentoo.org> <1252950003-9451-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1252950003-9451-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909141049.50705.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Monday 14 September 2009 10:40:03 am Mike Frysinger wrote:
> +
> +struct opencores_kbd {
> +	struct input_dev *input;
> +	struct resource *addr_res;
> +	struct resource *irq_res;
> +	unsigned short *keycode;
> +};

Why do we allocate keycode table separately form the main structure?

I think I still have some reservations with the notion that we can just
have exact "scancode" - KEY_* mapping and hardware producers will adjust
the hardware to follow the deriver but I guess it's OK...


-- 
Dmitry
