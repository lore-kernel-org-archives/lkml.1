Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXIRMmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXIRMmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXIRMmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:42:44 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:42418 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbXIRMmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:42:43 -0400
Date: Tue, 18 Sep 2007 08:42:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: alternatives in modules
Message-ID: <20070918124240.GB19953@Krystal>
References: <200709181337.00089.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200709181337.00089.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:41:03 up 50 days, 12:59,  6 users,  load average: 0.62, 0.72, 0.62
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko (vda.linux@googlemail.com) wrote:
> Hi Mathieu,
> 
> I was looking through kernel/module.c and if understand it
> correctly, it doesn't handle .altinstructions in modules at all.
> Am I reading code correctly?

Hi Denys,

See
arch/i386/kernel/module.c:module_finalize()
it calls apply_alternatives().
(and is called by load_module)

Mathieu

> --
> vda

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
