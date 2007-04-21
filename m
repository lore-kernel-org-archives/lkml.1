Return-Path: <linux-kernel-owner+w=401wt.eu-S1030781AbXDUMd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030781AbXDUMd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 08:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030805AbXDUMd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 08:33:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:3655 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030781AbXDUMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 08:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=S3MO3e4YmP220gbIODd57zro2cvk2K8LZKcBcB4cha4zzyJSOUYDJZVUlG5UxBhVp4Ta9OaeHSZaIeqdRBtAwtwbjZTgnvXmlauhYM+9K2BkQR9QGqlAQP8ms1Js3txG/9pdi3B0s1whzLlXK+wTijWaub0S1mmXzhfO+1+2OU4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.20.7 locking up hard on boot
Date: Sat, 21 Apr 2007 14:44:03 +0200
User-Agent: KMail/1.9.6
Cc: Greg KH <gregkh@suse.de>, Marcos Pinto <markybob@gmail.com>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Alan Cox <alan@redhat.com>, linux-pci@atrey.karlin.mff.cuni.cz
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com> <20070421053420.GA10974@suse.de> <20070421103632.GC4016@stusta.de>
In-Reply-To: <20070421103632.GC4016@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704211444.03365.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 21 April 2007, Adrian Bunk wrote:
> On Fri, Apr 20, 2007 at 10:34:20PM -0700, Greg KH wrote:
> > On Fri, Apr 20, 2007 at 11:30:59PM -0500, Marcos Pinto wrote:
> > >  Yes, I just tried 2.6.20.3 with ACPI enabled and it booted perfectly.
> > >  I'm hoping this means you know what's wrong? :-)
> > 
> > Can you do a 'git bisect' on the versions between 2.6.20.3 and 2.6.20.7
> > to try to find the problem patch?
> 
> Considering where it failed and that 2.6.20.3 worked, I would be 
> extremely surprised if this wasn't one more report of 
> adjust-legacy-ide-resource-setting.patch breaking booting (and we 
> already have confirmed reports for this)...
> 
> But AFAIK we still don't understand how this patch managed to break 
> things.

Same here but 2.6.21 is near and we need to do something about this issue.

I'm thinking about reverting this patch for 2.6.21-final - having broken
X server is better than having broken and not booting kernel.

Jan, Alan?

Thanks,
Bart
