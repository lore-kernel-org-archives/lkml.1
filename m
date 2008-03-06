Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbYCFMJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbYCFMJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765479AbYCFMGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:06:20 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:31047 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765348AbYCFMGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:06:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sHhLySyKrm2hGGBbrGHS3RztS2WKjLQRGOjJWnqlPJ6v+h7M0/m202T8YtJrjqYw1ewAdX6P2hnYWcDXn0Hx137ruOr2epd9DoMyrkM2HbXhQXHT/58PfNsIvuoRhSDaMA3FZFuT4Lw9Cdd2i9tAXhNUj0qgDW8aob5SkLaU0ts=
Message-ID: <84fc9c000803060406u7dfa0d38ve8af3154bf5064f9@mail.gmail.com>
Date: Thu, 6 Mar 2008 13:06:17 +0100
From: "Richard Guenther" <richard.guenther@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Cc: "Andrew Haley" <aph@redhat.com>, "Aurelien Jarno" <aurelien@aurel32.net>,
       "H. Peter Anvin" <hpa@zytor.com>, "Michael Matz" <matz@suse.de>,
       "Joe Buck" <Joe.Buck@synopsys.com>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
In-Reply-To: <871w6ogjnu.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080305153020.GA24631@volta.aurel32.net>
	 <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com>
	 <20080305202319.GA17053@volta.aurel32.net>
	 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	 <47CF0627.2070200@zytor.com> <47CF07FE.10200@aurel32.net>
	 <47CFBF28.4060309@redhat.com> <871w6ogjnu.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06 Mar 2008 12:45:57 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> Andrew Haley <aph@redhat.com> writes:
>  >
>  > I suppose one could apply the precautionary principle, but those systems that
>  > don't update kernels won't update gcc either, so the solution won't work.
>
>  You seem to assume that running a gcc 4.3 compiled binary requires a
>  gcc update. That is not necessarily true.

It (sometimes) requires a libgcc and libstdc++ update.

Richard.
