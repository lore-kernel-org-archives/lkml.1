Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbZDCVoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbZDCVoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935894AbZDCVnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:43:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:8655 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935331AbZDCVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:43:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rbTKsCY2RAMAyeEzcsDPbzjtqZRLBduH8NF1YSXxofw520jFCkTmxUoXCQaOWR2HTP
         tWCefgbnzwjYA/S3zrUXFPHSZ4RhrLqLcNsHZP9vDreTH9rHN2I7dhzJwYo4iieBb7Lj
         zAKAzspr9M5aWAZoOvRFyco4jqP5VEy7JtYJA=
MIME-Version: 1.0
In-Reply-To: <20090403210117.GA14582@sgi.com>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
	 <49D66E83.5070606@inria.fr>
	 <86802c440904031349v31f84f8anf082db7505e60387@mail.gmail.com>
	 <20090403210117.GA14582@sgi.com>
Date: Fri, 3 Apr 2009 14:43:47 -0700
Message-ID: <86802c440904031443g313d0c71i1751c7c5b4b9caf9@mail.gmail.com>
Subject: Re: Off topic: Numactl "distance" wrong
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://tracker.coreboot.org/trac/coreboot/browser/trunk/coreboot-v2/src/northbridge/amd/amdk8/amdk8_acpi.c
acpi_fill_slit()
could tell you how to generate slit according to hops on AMD opteron system.

then you could use /sys interface ( later ) to update acpi_slit in the kernel.
later __node_distance could get correct distance.

YH
