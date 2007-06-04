Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbXFDN7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbXFDN7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbXFDN7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:59:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:9095 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbXFDN7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gNBf71zcAdO7fBznIRpqf2d9AcjYgm9yU86Ze3Hm6ViVfO8uM9ylb1FXMhpVjcAYIy1UFqZdmi+MR5ojNt7wa9DYSfRhun2ce3FHWn8CnaFPsgi9hZrNL7nWLezCZRnkMtwphFrKxdR/TAn6FxLW/An+XWa2uUyjnSxUM1c89kw=
Message-ID: <e7ca40f70706040659k20f4fac6n137a570080c84be5@mail.gmail.com>
Date: Mon, 4 Jun 2007 09:59:19 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: slow open() calls and o_nonblock
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <18019.26871.317501.633363@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	 <18019.21781.470399.393340@stoffel.org>
	 <e7ca40f70706031805h56da4c3ag2dd0e902430785cc@mail.gmail.com>
	 <18019.26871.317501.633363@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/07, Neil Brown <neilb@suse.de> wrote:
>
> Have you tried the "nocto" mount option for your NFS filesystems.
>
> The cache-coherency rules of NFS require the client to check with the
> server at each open.  If you are the sole client on this filesystem,
> then you don't need the same cache-coherency, and "nocto" will tell
> the NFS client not to both checking with the server in information is
> available in cache.

No I haven't - I will research this a little further today.  While
we're not the only client using these filesystems, this process is
(currently) the only process that writes to these files.  Thanks for
the suggestion.

-Aaron
