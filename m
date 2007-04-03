Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbXDCFsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbXDCFsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXDCFsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:48:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:8512 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXDCFsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cTUgu9GZYDRZzPfhT45Sv1d1VzhJOXlQId4URlhakexwNN5gMDNu+oDTlr+5qSxs1SIzRKKjtAabWx2L/HXjxXHn5hnCsJHYibCdkoGyIk/MAJ3i4QV4fvLHtD7OjeYIfuwq4sjo63dmgmTJhuc78fh9Ja5+oBVV1VoLKMrNEbM=
Subject: Re: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4611D2C6.3090102@ums.usu.ru>
References: <4611ACCD.5000305@gmail.com>  <4611D2C6.3090102@ums.usu.ru>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 13:47:46 +0800
Message-Id: <1175579266.7267.28.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 10:06 +0600, Alexander E. Patrakov wrote:
> Antonino A. Daplas wrote:
> > Create a variable, default_utf8, that defines the system-wide default UTF-8
> > setting.  This variable can be altered via sysfs. If the variable is properly
> > set, this should mimimize breakage of UTF-8 encoded consoles when doing a
> > reset or echo -e '\033c' and of newly opened/allocated consoles.
> > 
> > This is based from patches by Jan Engelhardt and Paul LeoNerd Evans.
> > 
> > Signed-off-by: Antonino Daplas <adaplas@gmail.com>
> > ---
> >> I think you're missing the whole point of console reset.  Its purpose is 
> >> to force the console into a known-good state.  The fewer pieces of state 
> >> it leaves unset, the better.  To some degree it's less important what 
> >> that state actually is.
> > 
> > Okay, you convinced me. Hopefully this is acceptable to all parties.
> > 
> > Andrew,
> > 
> > If everybody agrees, can you drop the previous patch I sent to you, and use
> > this instead?
> > 
> > Tony
> > +static int default_utf8;
> > +module_param(default_utf8, int, S_IRUGO | S_IWUSR);
> 
> Module parameter without description and documentation? Yes, I understand 
> that it is impossible to make vt a module. How about adding a line to 
> Documentation/kernel-parameters.txt?

I'll do that (and I'll also include Jan's palette patch) once I'm sure
there's no violent objection against the change.

Tony 


