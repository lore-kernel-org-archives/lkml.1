Return-Path: <linux-kernel-owner+w=401wt.eu-S1765688AbXEVI17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765688AbXEVI17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXEVI1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:27:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:13947 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbXEVI1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MJO8fL+MnT1f551c1VAOSnxvZsZQpJ4vCijqowwI08gTIfwplyCiVTOW2QECnoXTae/LwQgtyv31GAKeFQ7LhJqKdAI4sZokVt8JO5PuEq6AiBBG7QqkpPEzXDxb/ZGtHfckAWcBih2UYNt0PyRYXABggQyIdFyCttlG5Fyhifc=
Message-ID: <21d7e9970705220127j6d92143ud0720e70e25c001a@mail.gmail.com>
Date: Tue, 22 May 2007 18:27:43 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jon Smirl" <jonsmirl@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <4652A6F9.1040502@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <4652295E.7060305@garzik.org>
	 <21d7e9970705220107mc096135nc26af32830d83646@mail.gmail.com>
	 <4652A6F9.1040502@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Did I say the X server? There are policy decisions that are root only
> > also authorisation of processes to render etc..
>
> Root only today, maybe, but this thread is talking about future
> directions.  Don't lock your design into a coarse-grained security model.
>

We can add a new capability bit but there are certain operations that
need privs especially if multiple users are involved. binding outputs
to crtcs being one.

Again I can see little reason that this wouldn't be possible going
forward. But i'm seeing policy decisions we currently make in the X
server needing to be made somewhere.

Dave.

>
> > I'm not sure we can punt all that in-kernel.
>
> See my response to Alan.
>
> 	Jeff
>
>
>
>
