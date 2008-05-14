Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYENQ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYENQ6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbYENQ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:58:27 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:58673 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757503AbYENQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:58:24 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [RFC] which drivers need to map ROM BARs?
Date: Wed, 14 May 2008 09:58:14 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080512205746.GB7401@us.ibm.com> <20080514000702.GA12546@us.ibm.com> <20080514162015.GA6713@us.ibm.com>
In-Reply-To: <20080514162015.GA6713@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805140958.14646.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 14, 2008 9:20 am Gary Hade wrote:
> > > that boot option will get rid of that ROM BAR for all devices...
> > > big system could use several graphical cards that need ROM BAR and
> > > several cards that don't need ROM BAR.
> >
> > Correct, not a perfect solution but better than we have right now.
>
> ...but don't let this comment make you think that I am not in
> favor of something like you are suggesting.  I am interested
> in getting the 'pci=norom' change into mainline quickly but it
> is obviously less than ideal for the long term.
>
> Jesse, any idea how many different devices absolutely need
> memory allocated for their expansion ROMs?

Well video devices are one obvious type.  Beyond that you'd have to audit the 
drivers in the tree looking for ones that map the ROM BAR (iirc qla1280 did 
this?).

Jesse
