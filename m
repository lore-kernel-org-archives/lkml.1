Return-Path: <linux-kernel-owner+w=401wt.eu-S965543AbXHaNpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543AbXHaNpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965160AbXHaNpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:45:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:42230 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964995AbXHaNpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:45:33 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX18MdVNo1ukMXc7lFpahglqY15/+fbln9rMvrSaRg9
	VNr3+evUpQ4u+7
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: "Chris Smith" <smitty1elkml@gmail.com>
Subject: Re: Copy large memory regions from & to userspace
Date: Fri, 31 Aug 2007 15:45:28 +0200
User-Agent: KMail/1.9.6
References: <200708310029.20734.clemens.kol@gmx.at> <9b53a56d0708310625q14defcb1l98ab8ce1df2c8fd7@mail.gmail.com>
In-Reply-To: <9b53a56d0708310625q14defcb1l98ab8ce1df2c8fd7@mail.gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311545.29154.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2007 15:25:40 you wrote:
> On 8/30/07, Clemens Kolbitsch <clemens.kol@gmx.at> wrote:
> > Hi!
> > Just a short question: What is the correct method of copying large areas
> > of memory from userspace into userspace when running in kernel-mode?
>
> relayfs?

no... I'm copying user-memory to user-memory, not kernel-to-user, however 
running the code in kernel-mode.

what i wanted to know is how to check the access-rights...
i didn't get any other answers, so for now i'm just using 

if (access_ok(VERIFY_READ, from, PAGE_SIZE) &&
    access_ok(VERIFY_WRITE, to, PAGE_SIZE))
{
    memcpy(to, from, PAGE_SIZE);
}

and hope that this is the *correct* way to do it...

