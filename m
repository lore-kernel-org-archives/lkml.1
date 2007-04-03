Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbXDCAxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbXDCAxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933940AbXDCAxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:53:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:64233 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911AbXDCAxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cOwta6wGNkHTj8st5le0NJoFGNtFb3fLMFQuM9KnG2XkA7U9dJVbkbDRLk4PvOqDVREkBDjXZgU8pDkHveYvsDoj4Lt98k76k0WwJoa9qanEaRWlPfmuYM9DsLXt3R2fff/vMjiSfTx7JhPcao+sgRTNWmuMRIko62RJ/mlH12U=
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>
In-Reply-To: <Pine.LNX.4.61.0704030220140.18387@yvahk01.tjqt.qr>
References: <46110F88.5040905@gmail.com>  <46113ED6.4060005@zytor.com>
	 <1175559377.7267.13.camel@daplas>
	 <Pine.LNX.4.61.0704030220140.18387@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 08:53:32 +0800
Message-Id: <1175561612.7267.22.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 02:23 +0200, Jan Engelhardt wrote:
> On Apr 3 2007 08:16, Antonino A. Daplas wrote:
> >
> >That would be the cleanest and purest behavior. But it's possible to set
> >one console to UTF-8 and another to legacy mode.
> 
> The question would be: why would you want to have mixed consoles?
> Switching to UTF8 IMO does not take away any characters, and I mean
> no-framebuffer 80x25 that is limited to 256 glyphs.

As long as we provide the users the capability to support mixed
encodings, the why is not important, it will happen. If we want to be
more restrictive, I guess, we can remove support for

echo -e '\033%G' and '\033%@'

Tony


