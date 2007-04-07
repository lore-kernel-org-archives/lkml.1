Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXDGDkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXDGDkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 23:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXDGDkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 23:40:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:50649 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXDGDkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 23:40:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VDDuFkp/kXPZUzodLUSbyAokKBfZkf42oPhV3W1B+noMGdgKEBRrtuE7HxKXvpZx4gQrlo0Zk0z4dQWHbvaWzNZnlOvRQ9vANSEx8+1FZuqdiGgYp8wqoYJne3GQIHQ/iOaFHoeWgGYGihvpF6dHj+zY5xaD1JxiziUibefF3NY=
Message-ID: <a4e6962a0704062040q12c0013ek9591b9fbb27caa12@mail.gmail.com>
Date: Fri, 6 Apr 2007 22:40:20 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 0/8] unprivileged mount syscall
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4616E459.1090409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <4616D4D4.6020405@zytor.com>
	 <Pine.LNX.4.61.0704070153180.22181@yvahk01.tjqt.qr>
	 <4616E459.1090409@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Jan Engelhardt wrote:
> > On Apr 6 2007 16:16, H. Peter Anvin wrote:
> >>>> - users can use bind mounts without having to pre-configure them in
> >>>> /etc/fstab
> >>>>
> >> This is by far the biggest concern I see.  I think the security implication of
> >> allowing anyone to do bind mounts are poorly understood.
> >
> > $ whoami
> > miklos
> > $ mount --bind / ~/down_under
> >
> > later that day:
> > # userdel -r miklos
> >
>
> Consider backups, for example.
>

This is the reason why enforcing private namespaces for user mounts
makes sense.  I think it catches many of these corner cases.

          -eric
