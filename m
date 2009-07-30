Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbZG3MLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbZG3MLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZG3MLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:11:04 -0400
Received: from mail-fx0-f210.google.com ([209.85.220.210]:32922 "EHLO
	mail-fx0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZG3MLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=RLUseRlSeTJ0Jn3tUG698C3cX8i/vGebbWm/PeNtrb4MrRN+S6SzurZt7wmu3OE7qQ
         cdwNPBkmrpWShD3vNMcNcnIxAECuBix6gvKr52vSZP6uuDOGZCvGpacdUD3F7++3C8/I
         9ff20L8hMD+q4tui6pz6MlmvJrnuHFaDf9i5Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: remove superfluous NULL pointer checks
Date: Thu, 30 Jul 2009 13:12:47 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
References: <200907300743.n6U7hnK6000821@mercury.physics.adelaide.edu.au>
In-Reply-To: <200907300743.n6U7hnK6000821@mercury.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907301312.48132.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 30 July 2009 09:43:49 Jonathan Woithe wrote:
> Hi Bart
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] fujitsu-laptop: remove superfluous NULL pointer checks
> > 
> > This takes care of the following entries from Dan's list:
> > 
> > drivers/platform/x86/fujitsu-laptop.c +327 set_lcd_level(13) warning: variable derefenced before check 'fujitsu'
> > drivers/platform/x86/fujitsu-laptop.c +358 set_lcd_level_alt(13) warning: variable derefenced before check 'fujitsu'
> 
> I'd rather keep the test for a non-null fujitsu in there, but obviously it's
> kind of pointless doing it after the first dereference.  Since this fixup
> overlaps with the one previously discussed with Julia I've taken the liberty

They are on top of Julia's patch (sorry I forgot to mention it)..
