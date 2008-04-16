Return-Path: <linux-kernel-owner+w=401wt.eu-S1764672AbYDPQVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764672AbYDPQVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763299AbYDPQVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:21:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:21901 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763208AbYDPQVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ojSJcyZ6RVZElhbTmbppWDmVNvf69uFnSSxsnaRfNuugoxFOsF3dXyyCCmZOI+jQOcIGz6LJ/Jliivq/dkEvD5QGZ8HmX4rG9X/CNBwVkKL7t0HxHq9zYFXOypgSDj1xuFIO40A4tFuKmWaseRQBvO3yISC16BHwMt6KPZtV9SA=
Message-ID: <55f6199c0804160921i55cc0fe7ycf45cb64933b84ad@mail.gmail.com>
Date: Wed, 16 Apr 2008 12:21:38 -0400
From: Disconnect <dc.disconnect@gmail.com>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: RFC: Self-snapshotting in Linux
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Scott Lovenberg" <scott.lovenberg@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <804dabb00804160806o39a2c89eg8d3a3387beb7b5cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajd42-7Gt-49@gated-at.bofh.it>
	 <db1091b2-68a6-4f71-800e-c4df6f8641ca@m44g2000hsc.googlegroups.com>
	 <804dabb00804160806o39a2c89eg8d3a3387beb7b5cb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 11:06 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>  This list is awesome.   After I read up on this kexec-based hibernation thing:
>
>  http://kerneltrap.org/node/11756
>
>  I realized it is about the same idea.   Some differences though:
>
>  My original starting point was VMWare's snapshot idea.   Drawing an
>  analogy from there, the idea is to freeze and restore back entire
>  kernel + userspace application.   For integrity reason, filesystem
>  should be included in the frozen image as well.
[snip]

It sounds like what you want is the existing ghost setup plus
swsusp/tuxonice.  Hibernate the system, which saves out your userspace
and kernel state, do the ghost save, then when you restore it'll boot
up right where it left off.

http://www.tuxonice.net
