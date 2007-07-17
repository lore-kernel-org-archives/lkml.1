Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbXGQCKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbXGQCKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 22:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXGQCKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 22:10:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXGQCK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 22:10:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Hf1yX3MEfNBbzxMW9C7pkcvKLHxWyd1JM4C3U0WObfNmjD5aIut/cGH7Wuz/due4d
	pyPgOA6LAoUgwsOWKcVlg==
Message-ID: <8f95bb250707161910j7b6e333cwd09d937709386a9f@mail.gmail.com>
Date: Mon, 16 Jul 2007 19:10:21 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Brown, Len" <len.brown@intel.com>, ak@suse.de, akpm@osdl.org
In-Reply-To: <1184636816.11983.1.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716180019.GA5112@google.com>
	 <1184636816.11983.1.camel@sli10-conroe.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Shaohua Li <shaohua.li@intel.com> wrote:
> On Tue, 2007-07-17 at 02:00 +0800, Aaron Durbin wrote:
> >
> > Add the ability to reset the machine using the RESET_REG in ACPI's
> > FADT table.
> We could have another command for 'reboot' kernel command line.
>

I did this in a separate patch for x86_64. See

http://www.ussg.iu.edu/hypermail/linux/kernel/0707.2/0319.html
and
http://www.ussg.iu.edu/hypermail/linux/kernel/0707.2/0319.html

-Aaron
