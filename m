Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZJ1WGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZJ1WGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZJ1WGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:06:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46230 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbZJ1WGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:06:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] PM / Hibernate: fix error handling in save_image
Date: Wed, 28 Oct 2009 23:08:04 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1255175505-7756-1-git-send-email-jirislaby@gmail.com> <20091010121723.GC1943@ucw.cz>
In-Reply-To: <20091010121723.GC1943@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910282308.04089.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009, Pavel Machek wrote:
> On Sat 2009-10-10 13:51:45, Jiri Slaby wrote:
> > There are too many retval variables in save_image. Thus error return
> > value from snapshot_read_next may be ignored and only part of the
> > snapshot (successfully) written.
> > 
> > Remove 'error' variable, invert the condition in the do-while loop
> > and convert the loop to use only 'ret' variable.
> > 
> > Switch the rest of the function to consider only 'ret'.
> > 
> > Also make sure we end printed line by \n if an error occurs.
> > 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ACK.

Applied to suspend-2.6/linux-next.

Thanks,
Rafael
