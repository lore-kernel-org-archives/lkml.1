Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXDUAi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXDUAi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXDUAi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:38:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:32145 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbXDUAiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ihXIOAdMtNQt0BG0ebyyCfojIMh2WHnWuA+UnvO/FMB/m52OQk19v7y2Zi+vSITqp6heZGNuevNtkV6FiTPKIZbEullHqaLiisipV475npolhFceMuYOoGVweMURkYfI3l8z8eZjF0dMLWFLKxObEdE+wF0CV60lnMe29ARaYUQ=
Message-ID: <cb7bb73a0704201738j4fdd610bgcfdb63fd0a5db232@mail.gmail.com>
Date: Sat, 21 Apr 2007 02:38:54 +0200
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
Cc: "Vojtech Pavlik" <vojtech@suse.cz>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, edouard.tisserant@wanadoo.fr
In-Reply-To: <Pine.LNX.4.64.0704210150140.5138@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com>
	 <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz>
	 <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com>
	 <Pine.LNX.4.64.0704201533300.5138@jikos.suse.cz>
	 <cb7bb73a0704200855xe841ecdoc9a0f67fc6f7009e@mail.gmail.com>
	 <d120d5000704200901m44c9a3aei9ee0572c3b0a61ab@mail.gmail.com>
	 <cb7bb73a0704200909h2f47e04cq87cb3dd91d7144f7@mail.gmail.com>
	 <20070420204724.GB5334@suse.cz>
	 <cb7bb73a0704201440i55557a13v5ad5a71617dc1239@mail.gmail.com>
	 <Pine.LNX.4.64.0704210150140.5138@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/07, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 20 Apr 2007, Giuseppe Bilotta wrote:
>
> > Oh, I see. I'll blacklist those modules, maybe also issue a ticket on
> > the Debian BTS.
>
> If Debian enables usbmouse and usbkbd by default in their standard
> kernels, would you be so kind and raise a proper ticket on them not to do
> so? Thanks.
>
> This also makes me to speed up with one of my items on TODO list - rename
> usbmouse and usbkbd to something that wouldn't be so confusing and
> wouldn't make people think that they should enable these drivers if they
> want support for USB keyboards/mice. Will queue this for 2.6.22.

Actually, I just found out that usbmouse and usbkbd are in the
blacklist file (/etc/modprobe.d/blacklist), so the fact that they are
being called reveals some kind of fscked up setup on my side. I'll try
to fix that, sorry for the noise.


-- 
Giuseppe "Oblomov" Bilotta
