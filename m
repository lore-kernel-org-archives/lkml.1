Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbYB1TPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbYB1TPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYB1TOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:14:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:5209 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbYB1TOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mGaQTnD3BNxatPY1IcjkYdMr/qOTfflHiBPSHfDMjPeqotul42ikpEEqiFoIhBKB6m8OVGXYUqLFjB3HeR8L6EyPWACMPfwVXK9Bjeia1hQMF8hIiZb4hB2e/zcL1LdClAEK3w8Iu+7OgIldo+MsClVhTQ6Djpf6a5jbu9gmakQ=
Message-ID: <38b2ab8a0802281114o5192251ew6f827e31b03551a2@mail.gmail.com>
Date: Thu, 28 Feb 2008 20:14:53 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: linux-v2.6.25-rc3 issue: nvidiafb: cannot ioremap FB base
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <22886.1204213070@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0802280607h46a89f04wdd190a7c87571668@mail.gmail.com>
	 <22886.1204213070@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 4:37 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 28 Feb 2008 15:07:27 +0100, Francis Moreau said:
>  > Hi,
>  >
>  > I gave to the latest -rc (rc3) a test and it appears to fail to load the
>  > nvidiafb module and the reason given is:
>  >
>  > nvidiafb: cannot ioremap FB base
>  >
>  > Does anybody have a clue ?
>
>  Umm.. do you also have vesafb or other FB built as a module?  I got bit by
>  that with the binary NVidia driver, discovered it was because vesafb had
>  already done an ioremap of the space, but with different caching flags...
>

no, actually I have only nvidiafb and it's built in the kernel (not a module).

Thanks
-- 
Francis
