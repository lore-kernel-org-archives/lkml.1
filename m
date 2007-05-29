Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbXE2QwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbXE2QwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbXE2QwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:52:03 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:26887 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXE2QwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b10iZhWZApHiunPrCwCnujbnwVRbSd8qjt0WNOV96naIiOVYyOW3VydQZiOfak5a5bGF6ImjG8HG5xYVfCG8PYjc7QXPsV77a2VH3L1F5Lgsq0LaNAFwNrs11Zflye+Qy9rMA4xWFH6IJBnIa71R2w4Gw0m/nOuz80XuZd3dODg=
Message-ID: <9e4733910705290951t3f59ae6dyc42a41e96b0c6cac@mail.gmail.com>
Date: Tue, 29 May 2007 12:51:53 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Dave Airlie" <airlied@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <20070529142631.GA6460@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465228E2.1030405@garzik.org>
	 <200705211856.56228.jbarnes@virtuousgeek.org>
	 <9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com>
	 <21d7e9970705220735j37bc8eeck87db7193c08c4c24@mail.gmail.com>
	 <9e4733910705220813i479a68faxf365697962317c60@mail.gmail.com>
	 <21d7e9970705221025r2f798dc5x310947db040c6521@mail.gmail.com>
	 <9e4733910705221258v660d8f42j16cc596ca820e8b8@mail.gmail.com>
	 <20070528201213.GA5840@ucw.cz>
	 <9e4733910705281357x592f0853re9492efdb5ef82e8@mail.gmail.com>
	 <20070529142631.GA6460@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Pavel Machek <pavel@ucw.cz> wrote:
> > I have already implemented this once and submitted a
> > patch.
>
> Seems you were not persistent enough. 'I submitted a patch long time
> ago' is still no reason to block new work.

This is a well researched area and the flaws are widely know. Adding
this new mode setting code to the kernel is not adding a new
subsystem, it is an attempt to replace an existing subsystem.  In
order to replace a subsystem the general rule is that the new one must
be better than the old one. I have not seen sufficient arguments made
to justify replacing fbdev instead of extending it.

As for writing more patches, I have been burnt once by "show us the
code" being used as a way to getting rid of someone when the people
saying "show us the code" have no intention of agreeing to the changes
being proposed. I'm not going to fall for it again.

-- 
Jon Smirl
jonsmirl@gmail.com
