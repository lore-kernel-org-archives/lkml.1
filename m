Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZDXJmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZDXJmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZDXJmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:42:20 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:44504 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbZDXJmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:42:19 -0400
Subject: Re: Patch to add mioa701 glue for voltage regulation
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: broonie@opensource.wolfsonmicro.com, eric.miao@marvell.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       philipp.zabel@gmail.com
In-Reply-To: <87iqkvp6i3.fsf@free.fr>
References: <87iqkvp6i3.fsf@free.fr>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 10:42:16 +0100
Message-Id: <1240566136.27410.3291.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-23 at 20:30 +0200, Robert Jarzmik wrote:
> Hi Mark and Eric,
> 
> I have that patch which adds voltage regulation definitions to mioa701
> board. The trick is, this patch depends on two others :
> 
>  - one which will be merged through Mark's regulator tree.
>    This one is mandatory as a compiling dependency exists through include files.
> 
>  - one which will be merge through Eric pxa tree.
>    This is the cpufreq one, and has a "very weak" dependency, as only the
>    "vcc_core" name _is_ the dependency.
> 
> I think the easiest way to solve the compiling dependency
> (include/linux/regulator.max1586.h) is to make that patch go through regulator
> tree as well for linux-next, even if it's arm machine specific, don't you ?
> 

If fine with this going through regulator providing I get an ACK from
Eric.

Liam

