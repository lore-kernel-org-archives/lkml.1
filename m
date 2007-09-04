Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbXIDX32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbXIDX32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 19:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbXIDX3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 19:29:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:46554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbXIDX3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 19:29:20 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: linux-pm@lists.linux-foundation.org
Subject: Re: Suspend and hibernation status report
Date: Tue, 4 Sep 2007 19:32:20 -0400
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <200707271057.05438.rjw@sisk.pl>
In-Reply-To: <200707271057.05438.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200709041932.21281.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 04:57, Rafael J. Wysocki wrote:

Thanks for writing this, Rafael.

> * system hibernation state - state, in which the system's processors are off and
>   its main memory is not powered, but the information necessary for continuing
>   the computations carried out when the system was last in a working state is
>   preserved in a storage space, such as a disk
> * ACPI S4 state - system hibernation state, in which some information is
>   preserved by the ACPI platform, in accordance with the ACPI specification

"some information is preserved by the ACPI platform" is sort of mis-leading.
What ACPI adds to the hibernate flow is some platform hooks to handle
wakeup devices, and a platform hook for the actual sleep request.
I'm not aware of any information saved by ACPI during S4 that is
not saved were the hibernate to be done with "acpi=off".

thanks,
-Len
