Return-Path: <linux-kernel-owner+w=401wt.eu-S935689AbXJPVTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935689AbXJPVTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965484AbXJPVSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:18:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:18944 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965506AbXJPVSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AFXGtosCJpeCSJMyhG7t0wLcGCAHZwI9WFGlkMAT+5OXmtEXHBdJEKtXqSsjb1XqJ6PISHr/kFhq2BY18THgLnAAGsQE54bb8M3e2587et3LbkWwYQjiryX4RtNdrR+juPkfrUKU8wK76rumoSXkKevDDODLN6H+MboOVhhlZ4c=
Message-ID: <d120d5000710161418r1f796a33n276cbd3fb3585ccd@mail.gmail.com>
Date: Tue, 16 Oct 2007 17:18:47 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Jeremy Katz" <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20071016205553.GA28531@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016130053.GA20010@srcf.ucam.org>
	 <20071016142121.GA21431@srcf.ucam.org>
	 <20071016143124.GB3237@khazad-dum.debian.net>
	 <20071016144016.GA21749@srcf.ucam.org>
	 <20071016165623.GA13643@khazad-dum.debian.net>
	 <20071016184606.GB25181@srcf.ucam.org>
	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
	 <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
	 <471523B6.7030506@intel.com> <20071016205553.GA28531@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Oct 16, 2007 at 01:48:54PM -0700, Kok, Auke wrote:
>
> > real life example: hook up one of those fancy usb keyboards with volume buttons to
> > your thinkpad. The volume keys on the thinkpad do adjust the volume, the ones on
> > the USB keyboard do not - software needs to be able to distinguish between them,
> > and sane defaults for these events need to not overlap.
>
> That's not a problem - they'll be coming from different input devices.
>

You could connect an external PS/2 keyboard and map some keys to
control the volume/brightness there. It most likely will be the same
device from the kerenl POV.

More important - is brightness and volume are the only notifications
userspace is interested in? Aren't there other events that might be
interesting to userspace?

-- 
Dmitry
