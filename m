Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbXCPSbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbXCPSbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXCPSbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:31:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:9090 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXCPSbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s25ub4WfsXOMTBQV+ZRPfri7k1coQjWkjEA3G5V5y7njUiDb90+rVkA4UYPNF5j0t5ZIhQarPq7DHdBkpoN7GAGnjCGSJEB7EY85AO7zuUYp+pD9APWKvdqroJ+5/zKf5YwfVsS6f1qc+oqricsbHhWOsB9OgYYDmBmJchtCrVg=
Message-ID: <5d6222a80703161131x48ff3548o8990abe5bb84da5@mail.gmail.com>
Date: Fri, 16 Mar 2007 15:31:20 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] Clean up ELF note generation
Cc: "Andi Kleen" <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45F8E272.2030903@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45F8E272.2030903@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -       note PT_NOTE FLAGS(4);  /* R__ */
> +       note PT_NOTE FLAGS(0);  /* ___ */
>  }

This seems to happen in at least 3 more architectures. Worth a broader cleanup?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"

"The less confident you are, the more serious you have to act."
