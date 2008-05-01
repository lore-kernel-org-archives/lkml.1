Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbYEAAY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbYEAAY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYEAAYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:24:19 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:63354 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYEAAYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aOlDInNknojKkVhjGEbtiGhaBd+Yg4h9+DlvHsxS7cIiKfNEjxuyPJQp2cz7syFYYgwR21Gt3nyRDwh7f2oWct9WNpEC/wbCnZDsQQX5YVDfKO9Aqcn8vzg2lhjF+Bntj7PxClosb+5BJ7wejUygjNCvd7UmolhWV2Th1fi2lZA=
Message-ID: <dd18b0c30804301724h2be338bfydba320b719190972@mail.gmail.com>
Date: Thu, 1 May 2008 00:24:13 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: ACPI vs proc_create_data() mismerge (was Re: proc_dir_entry 'info' already registered)
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0804301706590.5947@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804301538o35d0caf0x4a7e1c503cae0d6b@mail.gmail.com>
	 <20080501001002.GA4820@martell.zuzino.mipt.ru>
	 <alpine.LFD.1.10.0804301706590.5947@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 12:07 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  On Thu, 1 May 2008, Alexey Dobriyan wrote:
>  >
>
> > acpi_device_dir() is NULL until all files are createst, so everyting is
>  > created in straight in /proc/ and creation code warns.
>
>  Ok, I tested this on a laptop, it works for me. Committed. Thanks again,
>
>                 Linus
>


Hello; I ran into a problem, for some reason with adding:
acpi_device_dir(device) = device_dir;
I received:
acpi_video_device_aqdd_fs:   implicit declaration of function acpi_device
lvalue required as left operand of assignment =  after these errors, as a test
I went in and put /*acpi_device_dir(device); */ around that line then
recompiled, compiling went o.k., then rebooting
I'm not seeing any messages like before.
regards;


-- 
Justin P. Mattock
