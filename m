Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbZKYJAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbZKYJAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZKYJAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:00:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZKYJAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:00:31 -0500
Date: Wed, 25 Nov 2009 10:00:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: cannot compile linux-2.6-tip tree
Message-ID: <20091125090018.GD1940@jolsa.lab.eng.brq.redhat.com>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
 <20091124154511.GG21821@elte.hu>
 <20091124172208.GG1975@jolsa.lab.eng.brq.redhat.com>
 <1259101632.6188.6.camel@gimli.petrovitsch.priv.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259101632.6188.6.camel@gimli.petrovitsch.priv.at>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:27:12PM +0100, Bernd Petrovitsch wrote:
> On Die, 2009-11-24 at 18:22 +0100, Jiri Olsa wrote: 
> > On Tue, Nov 24, 2009 at 04:45:11PM +0100, Ingo Molnar wrote:
> [...] 
> > > It's rare but happens. 'make clean' will cure that.
> Apart from disk full, hitting quota limits may give similar errors.
no quota..

>
> [...] 
> > I tried make clean and it did not help..
> 
> - Did you change the architecture without `make mrproper` in between?
>   Yes, `make clean` should cure that but ....
it did not :) new tree clone did

> - Did some cross-gcc, cross-objdump, ... get in the PATH?
nope

> 
> Save .config, `make mrproper`, put .config back, `make` and see it it
> persists.
I did "git clean -xdf" to wipe all out and hit the same issue

thanks,
jirka
> 
> Bernd
> -- 
> Firmix Software GmbH                   http://www.firmix.at/
> mobil: +43 664 4416156                 fax: +43 1 7890849-55
>           Embedded Linux Development and Services
> 
