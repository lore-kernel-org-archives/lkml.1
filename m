Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZKCJGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZKCJGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZKCJGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:06:10 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36747 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZKCJGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:06:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g6fDzBSddPliDtymds9WUNSIUzGLH5QZZPqokbPJt4N2QFfV7840jEl6d7lPMWKZO+
         WWaOj3HulHZ0zzl1QWtBKSPhy04Dj+vPYurzEY9ZvWXlddpfmM8KbaLYr4RgWBjekTlg
         OUGEDnWifBOck0logML1G+yT46CQsDBjOBATw=
Date: Tue, 3 Nov 2009 12:06:08 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix X86_64 procfs provide stack information for threads
Message-ID: <20091103090608.GA3898@x200>
References: <1257158829.5199.26.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257158829.5199.26.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:47:09AM +0100, Stefani Seibold wrote:
> The 32 bit loader compat_do_execve did not store stack start (this was
> figured out by alexey).

yeah, but let's not mix it since these are two different issues
and KSTK_ESP should go through Ingo.
