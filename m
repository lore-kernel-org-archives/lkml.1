Return-Path: <linux-kernel-owner+w=401wt.eu-S2992429AbXBIRAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992429AbXBIRAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992440AbXBIRAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:00:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:15546 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992429AbXBIRAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K74Evj32LdStdo19eQlO+PWcEiFcfmCFqbkPJW0KGoJn19y/MaW/HdUAPHz7+HHzmEqsBecc1QsXOKwxLvR3fZy5cH9TAUYfRCtUt1uQvDw4frrxyv61usLnPWBuUaAb1pjlrNNstUW8G+QdEwMU16fSVsZlXAGeySk6goYCGf0=
Message-ID: <d120d5000702090900r1ad57d9dyb0c7f544686e7c40@mail.gmail.com>
Date: Fri, 9 Feb 2007 12:00:41 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: WHATIS scan_keyb
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <p73lkj71bcm.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45CC8F2D.3070902@gmail.com> <p73lkj71bcm.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Andi Kleen <ak@suse.de> wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
>
> > Hi.
> >
> > What's drivers/char/scan_keyb.{c,h} for, when it's referenced in no
> > place (aside a fact, that it uses some old API and hence is broken)?
>
> iirc it was an interface for braille reader modules. Probably they
> never made it into tree.
>

It looks like it is a generic portion of drivers for scan-matrix
keyboards. I think we can nuke it.

-- 
Dmitry
