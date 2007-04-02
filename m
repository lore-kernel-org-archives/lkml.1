Return-Path: <linux-kernel-owner+w=401wt.eu-S965796AbXDBUQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796AbXDBUQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965809AbXDBUQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:16:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:31201 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965796AbXDBUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y/KrGe2kU9oSShq0r6szaw/tHuSS54shvvbugNeTrIvJyHkHzQtjTMppU5Ce/KAI9y6Sn+RBMcbF2AI2A7z9/pT3FBkfgc6ePR9nGVRZIq+41ajOfaZJAc16hCnql3WAJHbExoL/I0k2iK1H6vn8vbmmsV/K9+ZCA1UnED5gf24=
Message-ID: <d120d5000704021316o7e30d51ej3f4a749ce5a49b5a@mail.gmail.com>
Date: Mon, 2 Apr 2007 16:16:03 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch 2.6.21-rc5-git 2/2] update Documentation/driver-model/platform.txt
Cc: "Greg KH" <gregkh@suse.de>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Andres Salomon" <dilinger@debian.org>
In-Reply-To: <200703311458.43800.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703311458.43800.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/07, David Brownell <david-b@pacbell.net> wrote:
> +A better solution is usually:
> +
> +       struct platform_device *platform_device_register_simple(
> +                       char *name, unsigned id,
> +                       struct resource *res, unsigned nres);
> +
> +You can use platform_device_register_simple() as a one-step call to allocate
> +and register a device.

DIdn't Russell want to convert eberything to platform_device_alloc and
then nuke platfrom_device_register_simple()?

-- 
Dmitry
