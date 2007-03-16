Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbXCPHXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbXCPHXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXCPHXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:23:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:4306 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXCPHXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cDZQrb4QPfGd6uJtKNSmwumNjD7BEKkLh/ftdh1iTWLDUugTt/lXjrQ1JqZXlhcjaUpfmyF49qyL8EeLkWptpwNaZRXhaZ0SyQj19sQqaSRs0pRNR5IMf1MGWgrKMcLbZkG55YVOszI4OzLF/Sl0oViNm6mLQHmjnQlnlA/BX24=
Message-ID: <84144f020703160023l61ef82a4yd3d64d2f4fe9f1a0@mail.gmail.com>
Date: Fri, 16 Mar 2007 09:23:22 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [BUG] Linux 2.6.20.2 - unable to handle kernel paging request - still accessing freed memory
Cc: linux-kernel@vger.kernel.org, "Chris Rankin" <rankincj@yahoo.com>
In-Reply-To: <20070315222707.GI31713@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170606.12059.qm@web52911.mail.yahoo.com>
	 <84144f020703140423h2562a353g40c156584943bb7@mail.gmail.com>
	 <20070315222707.GI31713@suse.de>
X-Google-Sender-Auth: 180da0acd3901193
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Greg KH <gregkh@suse.de> wrote:
> Is there any way you can use 'git bisect' to try to track down the root
> cause of this?

Chris, If 2.6.19 works for you, could you please do a git bisect for
this bug? See the following URL for details:

http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
