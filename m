Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZHUJff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZHUJff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 05:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZHUJfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 05:35:34 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61175 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbZHUJfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 05:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gmp77kaqAKLhIBdrQaHXXtjWahTZzR6Xyhxkt7Wz01ZF+ssZvHOKuKHKBpNg8lgGH5
         Xx6ZvBXOmtxT2gBINY8pfg2fbv2vlNgYLy7C6ja+1bG8lTJIlo4bkCguGTlL8ykUecJm
         XPgWoVZyvDt7tvMiGEj/Rw09vatQw8egfX9Ao=
MIME-Version: 1.0
In-Reply-To: <Era7U-todKF.A.wsC.gmIjKB@chimera>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
	 <Era7U-todKF.A.wsC.gmIjKB@chimera>
Date: Fri, 21 Aug 2009 10:35:33 +0100
Message-ID: <9b2b86520908210235l7961410ag74200291c7f8e3a5@mail.gmail.com>
Subject: Re: [Bug #13620] acpi_enforce_resources broken - conflicting i2c 
	module loaded on some EeePCs
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13620
> Subject		: acpi_enforce_resources broken - conflicting i2c module loaded on
> some EeePCs
> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date		: 2009-06-25 08:31 (56 days old)
> References	:
> <http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-June/002316.html>
> Handled-By	: Lin Ming <ming.m.lin@intel.com>
> Patch		: http://patchwork.kernel.org/patch/33626/

This must have been fixed in -rc6, because someone just complained
about it working again :-).
<http://article.gmane.org/gmane.linux.acpi.devel/40999/>

I confirmed this on my own EeePC; i2c-i801 is now correctly denied
access to the IO resources claimed by ACPI.  Please remove this
regression from your list.

Thanks
Alan
