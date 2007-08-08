Return-Path: <linux-kernel-owner+w=401wt.eu-S937698AbXHHVgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937698AbXHHVgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934722AbXHHVgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:36:04 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:34986 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765996AbXHHVgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iues1AHE6C7ambRk1v9AmBNXpAgSrUXERxKcPwlUKrA0b+VcztZsT+JHp4mjsSS1Yp9IKskDxnm92G2Vsbxq0SzzpgB5Up8wNlpwNd8ut/M9yz9sa+ZjuVTyGVnceOkQw+SS9o8vGAAQD4ke3V5Z8f/11dX9iXECgeD+eqfAXw8=
Message-ID: <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
Date: Wed, 8 Aug 2007 23:36:00 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 2/3] UIO: Documentation
Cc: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
In-Reply-To: <11848012122374-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070718232332.GA4620@kroah.com>
	 <11848012053678-git-send-email-gregkh@suse.de>
	 <11848012122374-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/2007, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> From: Hans J. Koch <hjk@linutronix.de>
>
> Documentation for the UIO interface
>
...
> +<para>If you use UIO for your card's driver, here's what you get:</para>
> +
...
> +<listitem>
> +       <para>if you need to keep some parts of your driver closed source,
> +       you can do so without violating the GPL license on the kernel.</para>
> +</listitem>
> +</itemizedlist>
> +
...

Do we really want this?

In my oppinion we run the risk here of encouraging behaviour akin to
what NVidia is doing - release a small kernel "glue" module and then
keep the driver proper in a binary blob (in userspace, but still a
binary blob).
If the company goes out of business and take their driver source with
them then users are left with a useless, un-debugable, un-maintainable
binary blob.
Don't we instead want to encourage/pressure people to release specs
and/or source code for their hardware/drivers so open, modifiable
drivers can be written?

This opens the door for people to start writing closed drivers. In the
long run that seems to me like a bad deal for our users.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
