Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZFENCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZFENCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZFENCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:02:32 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:64906 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZFENCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h7CxKawO5BnPjwfOgNulg3em1Onx+dXxF7CHyO5rc1+axiVlqpxbc6hELaS4/mFAzs
         UeNNtsRJG+XUToBOsWDDfw7ClhD+mSywyecrMC9Uv78IVGaEOD+AkZ/5SYtZYtKvFt/N
         SuA0WcucFpNTvQmD0Pxi7ZDmO9CK+LipYZ2IA=
MIME-Version: 1.0
In-Reply-To: <1244205844.23533.21.camel@penberg-laptop>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
	 <1244205844.23533.21.camel@penberg-laptop>
Date: Fri, 5 Jun 2009 15:02:28 +0200
Message-ID: <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Corentin Chary <corentin.chary@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 2:44 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
> Hi Corentin,
>
> On Fri, 2009-06-05 at 13:46 +0200, Corentin Chary wrote:
>> First, I think a one line
>> set_acpi(CM_ASL_CAMERA, 1);
>> with a small comment is better. (If it fails, it's because there no
>> camera, so we don't mind).
>
> OK, I've included an updated version of the patch.
>
> On Fri, 2009-06-05 at 13:46 +0200, Corentin Chary wrote:
>> Anyway, I'm not sure it's a good idea to enable the camera by default.
>> It depends how many power the camera is using (when idle). Coud you
>> check that (with power top maybe ?).
>
> People who prefer power savings over functional camera can always
> disable it. If you look at the amount of "my camera doesn't" work bug
> reports, I think it's pretty evident that we should enable it by default
> or provide a config option that does it.

Ok, your right, I'll apply that one

> That said, I am more than happy to measure this but I need a little bit
> more information to get started as I have never used powertop. So what
> is it exactly you want me to do?

PowerTop (with a corretly configured kernel) will give you a power
usage estimate.

CONFIG_NO_HZ=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_KERNEL=y

For propers results, shutdown all services and just keep a shell
(without X or network).
You can also test that with and without the camera driver.

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
