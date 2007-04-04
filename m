Return-Path: <linux-kernel-owner+w=401wt.eu-S2992939AbXDDPw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992939AbXDDPw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934056AbXDDPw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:52:26 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:53074 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934048AbXDDPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:52:25 -0400
Message-ID: <4613C963.6070409@gmail.com>
Date: Wed, 04 Apr 2007 17:50:59 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet> <20070404150231.GE27660@stusta.de>
In-Reply-To: <20070404150231.GE27660@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2007 05:02 PM, Adrian Bunk wrote:

>>> #define MODULE_MAINTAINER(x) MODULE_AUTHOR(x), please. 
>>> MODULE_AUTHOR really has meant maintainer in practice for ages,
>>> and it's the only actually relevant for users information we
>>> should store.
>> 
>> I agree. The actual author information belong into the files
>> copyright header. The MODULE_AUTHOR should only show the current
>> maintainer and its email address. However this might need some
>> cleanup. Maybe it is time that we sync the MAINTAINERS file with
>> the MODULE_AUTHOR tag.
> 
> Or even remove the MODULE_AUTHOR tag?
> 
> Even if you would spend the time for syncing the > 1600 MODULE_AUTHOR
> tags today, I don't see this happen on an ongoing basis in the
> future.

Given that people seem to agree that authorship information has no place 
in the binary, that might actually be best.

The problem I'm trying to solve is letting people know whom to contact. 
Having multiple authors in the MODULES_AUTHOR tag and maintainers who 
might not be authors are two reasons the current tag doesn't work.

Keeping copyright holders in a copyright header and maintainers in the 
MAINTAINERS file would at least avoid the confusing message the tag 
sends. As you say in a previous message, users should mostly in fact be 
contacting their vendor if using distro kernels or, if they're using 
kermel.org kernels, linux-kernel and can then find the information in 
the MAINTAINERS file.

So, MODULE_AUTHOR be gone?

Rene.
