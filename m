Return-Path: <linux-kernel-owner+w=401wt.eu-S1759725AbZDGXcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbZDGXcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZDGXcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:32:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:48109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbZDGXcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:32:10 -0400
Message-ID: <49DBE295.9020900@kernel.org>
Date: Tue, 07 Apr 2009 16:32:37 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Genoni Luigi <luigi.genoni@telecomitalia.it>
CC: "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nvida sata controller CK804  and  NCQ not working on linux-2.6.28||29.1
References: <8260162D332466469A1DD3FB317C18882E665616BA@GRFMBX706RM001.griffon.local>
In-Reply-To: <8260162D332466469A1DD3FB317C18882E665616BA@GRFMBX706RM001.griffon.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 23:31:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Genoni Luigi wrote:
> Hi,
> to make NCQ work with nvidia sata CK804 I had to introduce this simple
> change into sata-nv.c. Is there some reason I am missing why adma_enable is
> not by default one, so later in the dome NCQ is not enabled?

You can simply use module parameter - sata_nv.adma=1.  It's disabled
by default because it's unstable on certain configurations.

Thanks.

-- 
tejun
