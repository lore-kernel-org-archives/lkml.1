Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYJWOzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYJWOzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYJWOzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:55:37 -0400
Received: from vena.lwn.net ([206.168.112.25]:44483 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbYJWOzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:55:36 -0400
Date: Thu, 23 Oct 2008 08:55:33 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: cafe_ccic: possible reason why gqcam is not working
Message-ID: <20081023085533.6828ee0b@bike.lwn.net>
In-Reply-To: <49004133.7090805@freemail.hu>
References: <49004133.7090805@freemail.hu>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 11:17:39 +0200
Németh Márton <nm127@freemail.hu> wrote:

>  - gqcam currently only supports video4linux 1, and it uses the
> following ioctls: VIDIOCSPICT, VIDIOCSWIN, VIDIOCGCAP, VIDIOCGWIN and
> VIDIOCGPICT.

...and that, of course, is the problem.  The V4L1 emulation in the
kernel cannot do a perfect job of things.  This application really
needs to be dragged forward to V4L2 if it is to work well with
contemporary video drivers.

Thanks,

jon
