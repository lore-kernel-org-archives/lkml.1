Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYF0KqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYF0KqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYF0KqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:46:12 -0400
Received: from www.tglx.de ([62.245.132.106]:38565 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYF0KqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:46:11 -0400
Date: Fri, 27 Jun 2008 12:43:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: monstr@seznam.cz
cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 26/60] microblaze_v4: time support
In-Reply-To: <1214483429-32360-27-git-send-email-monstr@seznam.cz>
Message-ID: <alpine.LFD.1.10.0806271240461.3297@apollo.tec.linutronix.de>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-12-git-send-email-monstr@seznam.cz> <1214483429-32360-13-git-send-email-monstr@seznam.cz> <1214483429-32360-14-git-send-email-monstr@seznam.cz> <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz> <1214483429-32360-17-git-send-email-monstr@seznam.cz> <1214483429-32360-18-git-send-email-monstr@seznam.cz> <1214483429-32360-19-git-send-email-monstr@seznam.cz> <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz> <1214483429-32360-22-git-send-email-monstr@seznam.cz> <1214483429-32360-23-git-send-email-monstr@seznam.cz> <1214483429-32360-24-git-send-email-monstr@seznam.cz> <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz> <1214483429-32360-27-git-send-email-monstr@seznam.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, monstr@seznam.cz wrote:
> +
> +static inline void udelay(unsigned long usec)
> +{
> +}

shouldnt this function be named zerodelay() ?

Thanks,
	tglx



