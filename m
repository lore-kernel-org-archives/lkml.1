Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYAWO2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYAWO2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbYAWO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:28:07 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:35181 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYAWO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:28:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c+EcfPA0sWiwg014LHEk2neWWXOa5y+IMYOrcjgvOpGTk6GZ5b5MMUgyz7Y9C3d5Z3DQvIdfY0yCgoj/QISg62KfaxDk+T/RnCQ/t7MQPNBVCsvy0DdCI4u9djrXrat5HCXkaNDeDKcVJu/mVMxgoNXOWPUWnCoS+PZLQUUmIBc=
Message-ID: <9e4733910801230628w18285de2p211d761826e8064a@mail.gmail.com>
Date: Wed, 23 Jan 2008 09:28:01 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCHv2] i2c: adds support for i2c bus on Frescale CPM1/CPM2 controllers
Cc: "Jochen Friedrich" <jochen@scram.de>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, "Scott Wood" <scottwood@freescale.com>,
       "Linux I2C" <i2c@lm-sensors.org>
In-Reply-To: <20080123140232.67273b22@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <477BEB60.4070703@scram.de>
	 <20080103104121.58697148.sfr@canb.auug.org.au>
	 <20080123112941.23250948@hyperion.delvare> <479723CE.5020609@scram.de>
	 <20080123140232.67273b22@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/08, Jean Delvare <khali@linux-fr.org> wrote:
> Hallo Jochen,
>
> On Wed, 23 Jan 2008 12:23:58 +0100, Jochen Friedrich wrote:
> > Hi Jean,
> >
> > > Do you have an updated patch addressing Stephen's comment?
> > >
> > > Note: you'd rather send updates of this patch to the i2c list rather
> > > than LKML.
> >
> > I'm currently looking at that last patches from Jon and try to make this
> > driver fit in there (+ the class override stuff).
>
> I'm not sure what patches exactly you're talking about, but the
> aliasing stuff Jon and myself have been working on are still under
> debate. Your patch shouldn't assume that any of these patches will go
> upstream immediately, so your patch adding the i2c-cpm driver can
> ignore them. I'll update the patches before merging them as needed, do
> not worry too much about that.

He wants the module name translation support I split out into powerpc-common.c.

>
> > Note: will do. I just subscribed to this list.
>
> Note hat you do not need to be subscribed to post to the i2c list (but
> of course, if you have some interest in Linux i2c development,
> subscribing was a good idea anyway.)
>
> --
> Jean Delvare
>


-- 
Jon Smirl
jonsmirl@gmail.com
