Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZJLDOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZJLDOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZJLDOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:14:46 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:38008 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZJLDOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TNPKo6p3p/CuimFNOqa9sbm6nButst+6ryxxc+7WvWDf6EQNw/Tm48H4U+3rdUt4Ik
         nbDQPh4qT+UqqBBqsWiohUNrBZxgqkIMjcpYBrXyCufrhEkgdkel1ZAt7GSIpv5Cs3iO
         GDSowG77QlJXVrGp3ghy28BnkKVQw9/XXxAkA=
MIME-Version: 1.0
In-Reply-To: <r-4Wjt4coy.A.ZrC.Ual0KB@chimera>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	 <r-4Wjt4coy.A.ZrC.Ual0KB@chimera>
Date: Sun, 11 Oct 2009 20:14:09 -0700
Message-ID: <dd18b0c30910112014m4bfdc238j542864bb9f1e8161@mail.gmail.com>
Subject: Re: [Bug #14379] ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to 
	expected String
From: Justin Mattock <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 3:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14379
> Subject         : ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2009-10-08 21:46 (4 days old)
> References      : http://marc.info/?l=linux-kernel&m=125504031328941&w=4
>
>
>

pulled rc4 today and the warning is still present.
here is the results of git bisect:

d9adc2e031bd22d5d9607a53a8d3b30e0b675f39 is the first bad commit
commit d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Jul 27 11:31:10 2009 +0800

    ACPICA: reformat predefined method table, no functional change

    Reformatted the methods that return package objects.

    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

:040000 040000 17c30a6e75ce2fafc677b32bdcf3fbecae8458ab
f43e38a2a4034bcc73ef14943e61187f11b08731 M      drivers

I will go and attach the git log to the bug report.

-- 
Justin P. Mattock
