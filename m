Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbXISLgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbXISLgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXISLgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:36:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:43418 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbXISLgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:36:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GhdWsS8pyKUyuwKsGUhXufdufqDXZVeKo2vXTbdgKnzjYC1b9PzTSPR0Td1okmWNiQmC8ILkJjoIPF+P29bWTB5js8Lv+nZj75ka7hHrdVohnfYJAJTr+znCwfMpY2vu9Kyn14fZ/fovepmQG1yXVmYVcqGWSYbfWl4zaAEDAGk=
Message-ID: <3ae72650709190436m1051aaddo1df73fc5b3f91b23@mail.gmail.com>
Date: Wed, 19 Sep 2007 13:36:15 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Subject: Re: iso9660 vs udf
Cc: "Satyam Sharma" <satyam@infradead.org>, "Jan Kara" <jack@suse.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070919083640.GC11444@mette>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070915214926.GA31416@mette>
	 <20070918144734.GB13304@atrey.karlin.mff.cuni.cz>
	 <alpine.LFD.0.999.0709190534490.26241@enigma.security.iitk.ac.in>
	 <20070919004657.GB11444@mette>
	 <alpine.LFD.0.999.0709190736140.28653@enigma.security.iitk.ac.in>
	 <20070919083640.GC11444@mette>
X-Google-Sender-Auth: 52d149a709adc71c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Andries E. Brouwer <Andries.Brouwer@cwi.nl> wrote:
> On Wed, Sep 19, 2007 at 08:05:32AM +0530, Satyam Sharma wrote:
>
> > I was actually asking for the logs explaining why you thought
> > the _kernel_ incorrectly "announced" it as an UDF filesystem.
>
> No, the CDROM announces itself as an UDF filesystem.
>
> > Hmm ... those "CD-RTOS", "CD-BRIDGE" and "CDUDF File System - Adaptec Inc"
> > bits are not dmesg output, are they?
>
> No, hexdump of the CDROM.

Care to provide:
  /lib/udev/vol_id /dev/...
and:
  blkid /dev/...

Or "dd" the start of the disk to a file, and send it to me, if there
is nothing confidential on it.

Thanks,
Kay
