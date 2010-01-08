Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895Ab0AHHEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab0AHHEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 02:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208Ab0AHHEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 02:04:10 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:55264 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0AHHEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 02:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O5tszVHCIRBXx2Lhmi+8V6gL/fceUHHnKjUbusJJ4GHqr6aMiOVrpTVIg5ZSgS0D7L
         RUEkbYL23pJMQrVMDRtiznC2422oFNbOpqZ86jxFt30Rq3VLfqyO+mF8jIukRi0pSBgA
         HEJAmE3UQwWmImpJIEy30zDsDTos0gMVfli6M=
MIME-Version: 1.0
In-Reply-To: <20100107145126.22271109.akpm@linux-foundation.org>
References: <b9df5fa11001030527h71b66dbcgd4ef29c04545cdaf@mail.gmail.com>
	 <20100107145126.22271109.akpm@linux-foundation.org>
Date: Fri, 8 Jan 2010 13:04:05 +0600
Message-ID: <b9df5fa11001072304i71b7e08ctb4f71504cee4f45d@mail.gmail.com>
Subject: Re: [PATCH] acpi: Fix unused variable warning in sbs.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/10, Andrew Morton <akpm@linux-foundation.org> wrote:

>
>  I wonder if it can be fixed in Kconfig.  Is there any sane use of
>  this code when CONFIG_ACPI_SYSFS_POWER=n && CONFIG_ACPI_PROCFS_POWER=n?
>
No. Making it depend on CONFIG_ACPI_SYSFS_POWER ||
CONFIG_ACPI_PROCFS_POWER, doesn't make sense too.
What about wrapping around acpi_battery_remove with #ifdef from
it's calling point.
