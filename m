Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYG2U1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYG2U1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYG2U1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:27:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21049 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYG2U1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=m0DVA4h1VHrRdiGv0EqQnlZdrYdJBxx72tqLRWL/37x2M2N7oNCxw/EjxojlCDMhVa
         5Wyxcxzwg8YG47OqlYlO+oK3PY/e1zwY5CSIqdu/kipwralHJWRNhLyxUss0S3Q9DTlp
         4LvJPYCvlKRI+ro1F/2h2RmTsnQyD70b+a/kA=
Date: Tue, 29 Jul 2008 22:27:32 +0200
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/5] docsrc: build Documentation/ sources
Message-ID: <20080729202732.GB6007@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Sam Ravnborg <sam@ravnborg.org>
References: <12173619152424@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12173619152424@xenotime.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 01:05:15PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Currently source files in the Documentation/ sub-dir can easily bit-rot
> since they are not generally buildable, either because they are hidden
> in text files or because there are no Makefile rules for them.
> This needs to be fixed so that the source files remain usable and good
> examples of code instead of bad examples.
> 
> Add the ability to build source files that are in the Documentation/ dir.
> Add to Kconfig as "BUILD_DOCSRC" config symbol.
> 
> Use "CONFIG_BUILD_DOCSRC=1 make ..." to build objects from the
> Documentation/ sources.  Or enable BUILD_DOCSRC in the *config system.

How about simply adding another makefile target instead? This is more
intuitive, imho, and complies with the Kbuild conventions so far.
Something like:

make docsrc

similar to 'make help' or 'make pdfdocs' etc.

[..]
-- 
Regards/Gruﬂ,
    Boris.
