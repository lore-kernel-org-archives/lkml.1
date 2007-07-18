Return-Path: <linux-kernel-owner+w=401wt.eu-S1763467AbXGRWsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763467AbXGRWsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbXGRWsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:48:11 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:42520 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbXGRWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VigqKBp0Q5uJOoC1ktxKkTDRFqwqkVjtnf8sLkgpqf9IurJK2qOW8ZxmWhzAGt9aD+DxlUA5x28dtccH7Z/GL81AjquBLh2J9sqXR+wiDBvSQ8fxbsOrIl1pyCCMBUU0f0I4ply7B3793nWhRqIBbHmSfLpChOP8YlYH1P+X1Sc=
Subject: Re: VESAFB CUSTOM RESOLUTION
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
In-Reply-To: <469E502E.8060000@zytor.com>
References: <200707181342.00647.a1426z@gawab.com>
	 <200707181645.01097.a1426z@gawab.com> <1184768426.4523.20.camel@daplas>
	 <200707181752.29478.a1426z@gawab.com> <1184771227.4523.24.camel@daplas>
	 <469E502E.8060000@zytor.com>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 06:48:03 +0800
Message-Id: <1184798883.4523.80.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 10:38 -0700, H. Peter Anvin wrote:
> Antonino A. Daplas wrote:
> > 
> >> What about the VBE 3.0 arbitrary vertical refresh rate thing?
> > 
> > This is not implemented by the video-vesa.c because it will require
> > complex calculations of mode timings (such as with GTF) to be done
> > before starting the kernel.  However, uvesafb probably does.
> > 
> 
> There is no real reason video-vesa.c couldn't do those calculations, but
> it would have to get the information from the command line proper and
> not just from the 16-bit vga= mode number.  That is a minor
> complication, but not significant (the new setup code has a proper
> command line parser.)
> 
> The desirability of it is another matter, especially since it wouldn't
> let any switching happen at runtime.

Yes, it's a lot of extra code that will be used only once, I would
rather not have it in the setup code. It's more appropriate for uvesafb
to implement that functionality.

Tony


