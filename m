Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYIYPWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYIYPWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYIYPWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:22:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44082 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYIYPWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:22:13 -0400
Message-ID: <48DBAC93.5070108@redhat.com>
Date: Thu, 25 Sep 2008 11:21:55 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Matthew Bodkin <matthew.bodkin@innovationone.ca>
Subject: Re: [PATCH 07/18] lirc driver for the CommandIR USB Transceiver
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>	<1220933164-10160-2-git-send-email-jwilson@redhat.com>	<1220933164-10160-3-git-send-email-jwilson@redhat.com>	<1220933164-10160-4-git-send-email-jwilson@redhat.com>	<1220933164-10160-5-git-send-email-jwilson@redhat.com>	<1220933164-10160-6-git-send-email-jwilson@redhat.com>	<1220933164-10160-7-git-send-email-jwilson@redhat.com>	<1220933164-10160-8-git-send-email-jwilson@redhat.com> <20080910110904.54de7268@bike.lwn.net>
In-Reply-To: <20080910110904.54de7268@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> This driver has real locking problems.  Parts of it depend on the BKL, but
> I would have a hard time arguing for the addition of new BKL users in this
> century.  The assumption that ->open() is called under the BKL no longer
> holds.  It's really time to put a proper lock here.

The kernel-space drivers for CommandIR devices are being dropped entirely, in 
favor of the new userspace driver for it, which is included in the lirc 
0.8.4pre1 userspace.

-- 
Jarod Wilson
jarod@redhat.com

