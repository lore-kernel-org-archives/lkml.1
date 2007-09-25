Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbXIYLZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbXIYLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXIYLZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:25:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:29653 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbXIYLZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:25:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Qfw1kx+GqXV268dtIxG/38KV5okaUig9rwHjFhGGlcu9JNJw0qvEFmQEfRFle9IB8NAYN826GTFr5QZ3Nlp1MWmzKwtv0SiLu2iMoS3h091etoApCbXQy3sWJ5p0oreoUWBpcNf2RyUJQ1OSuF+5tNi7o1CS6HYxKMW8nesNMys=
Message-ID: <46F8F033.2040402@gmail.com>
Date: Tue, 25 Sep 2007 15:25:39 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Damien Wyart <damien.wyart@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925065109.GA3080@localhost.localdomain>	 <20070925003340.5d6dd7f4.akpm@linux-foundation.org>	 <46F8C880.1010006@suse.de> <64bb37e0709250208gcbdeb6do6026e138e746bde2@mail.gmail.com>
In-Reply-To: <64bb37e0709250208gcbdeb6do6026e138e746bde2@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On 9/25/07, Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
>> Do you have CONFIG_ACPI_SLEEP enabled in your .config?
> 
> I'm answering that too, because I suspect that my "2.6.23-rc7-mm1 does
> not power off"-error might have the same cause.
> 
> No, I do not have CONFIG_ACPI_SLEEP set,
> because I do not have CONFIG_PM_SLEEP set,
> because I do not want SUSPEND and/or HIBERNATION.
This is not the reason. SUSPEND is controlled with CONFIG_SUSPEND and 
HIBERNATION is controlled with CONFIG_HIBERNATION.
But if you want S5 ACPI sleep state you might want to enable ACPI_SLEEP...
> 
> .config from 2.6.23-rc7-mm1 attached.
> 
> Torsten
> 

