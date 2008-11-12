Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYKLXqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYKLXqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYKLXql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:46:41 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:17048 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYKLXqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PHn+ZbZ7dhGfutg1Y6cQvqAkApS0IQ4/RPelv3N4zeFu4HuCvVCeBQ9JZAVp3GVrLJ
         RmyqgaAB29STlMrmc4vF8MDNg2DwbrbKn8FKAeCvw5NqBvRZlZnfHBibyUviJ9b3g1nY
         dLNUsfGIsiMRe/9Z7+U+AuGD5MvrVLadcWnWI=
Date: Wed, 12 Nov 2008 18:46:48 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Greg KH <greg@kroah.com>, Mike Frysinger <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: kill WLAN_CPU_FAMILY and WLAN_SYSARCH
Message-ID: <20081112234648.GA25675@tuxbook-pro>
References: <1226500540-9667-1-git-send-email-vapier@gentoo.org> <20081112224628.GD27479@kroah.com> <8bd0f97a0811121536r4967b5ddh675a60216c1fb800@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0811121536r4967b5ddh675a60216c1fb800@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 06:36:57PM -0500, Mike Frysinger wrote:
> On Wed, Nov 12, 2008 at 17:46, Greg KH wrote:
> > On Wed, Nov 12, 2008 at 09:35:40AM -0500, Mike Frysinger wrote:
> >> The WLAN_CPU_FAMILY and WLAN_SYSARCH defines are used in all of three places
> >> (two of which look pretty suspect), so just kill them off rather than
> >> throwing up a pointless #error on processors that are not in the existing
> >> list.
> >
> > Thanks, but this is already cleaned up in my tree with a patch from
> > someone else.
> 
> where ?  i looked in staging.git and that hasnt been touched in 2 months.
> -mike

Greg has been using patches.git, not staging.git

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
