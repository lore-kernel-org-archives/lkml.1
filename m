Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYIJNJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYIJNJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYIJNI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:08:57 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62937 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYIJNI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rTjlUoWpz7pZ0rFGZUQC1AhsU7rcD8DRgsxHswwUvtFGGs7y4jPvzIPOnVupOZi1hD
         jhyIHCxZeEwCjuf8c5q61Y+vDzrvexJiPAtZJYmgbuRLjA9kh25cJ1/LmKUV55L+OsNk
         pya1K+NRIzA2Tiochd30klJe8K8c5CSS8l5/Q=
Date: Wed, 10 Sep 2008 09:08:51 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080910130851.GC25221@anvil.corenet.prv>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220933164-10160-2-git-send-email-jwilson@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarod,

On Tue, Sep 09, 2008 at 12:05:46AM -0400, Jarod Wilson wrote:
> -Add Kconfig and Makefile bits
> -Add device driver interface and headers
> 
> The initial Kconfig and Makefile bits were done by Mario Limonciello for
> the Ubuntu kernel, but have been tweaked a bit since then. Any errors are
> probably my doing.
> 

Couple of questions - what is missing in the current input core to
properly support IR devices? How can we enhance it to not need new
subsystem to handle such devices? We already have in-kernel support for
some of the devices you are adding (ATI remotes, xbox, etc) so the
situation is not ideal. Could we try to work it in ininput core and
maybe provide LIRC device access through an input handler
implementation so that applications do not have to implement 2 types of
interfaces?

-- 
Dmitry
