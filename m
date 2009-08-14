Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZHNAfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZHNAfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 20:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZHNAfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 20:35:02 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:40144 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbZHNAfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 20:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YA8/49SyU/TZ/EYEUXuPQbHBpDETQyipMGhPkvToY+yTPQSHAE4mYUiMNJkjgn8B3o
         tOS1p3EItCuWPAXdyeh6JgXBTElrBqI8JufAaOlTKSWDnaKCKsfPwhnHmDhBAfFk+Cce
         zIipjLC6iGgv6pMbYtnJeSFInSmhHVJ6hVQ18=
MIME-Version: 1.0
In-Reply-To: <20090813234410.GB4406@kroah.com>
References: <1250046053-3097-1-git-send-email-vapier@gentoo.org> 
	<20090813234410.GB4406@kroah.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 13 Aug 2009 20:34:40 -0400
Message-ID: <8bd0f97a0908131734h2588d240k9000bace38b58e7f@mail.gmail.com>
Subject: Re: [PATCH] USB: isp1362: fix build warnings on 64-bit systems
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lothar Wassmann <LW@karo-electronics.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 19:44, Greg KH wrote:
> On Tue, Aug 11, 2009 at 11:00:53PM -0400, Mike Frysinger wrote:
>> A bunch of places assumed pointers were 32-bits in size (bit checking and
>> debug output), but none of these affected runtime functionality.
>>
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> This patch doesn't apply to my tree, what did you make it against?

it was reported against next, so i used that
-mike
