Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbYB2N0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbYB2N0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYB2N0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:26:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:46313 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYB2N0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:26:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GC4dhMgf7LiY4Bjt+RtN67E7S2JX23MrSJpIqf9QlUdbA3AOxWMCfRsx4lht7BfA4t2tncO0EF/cgeC4iZb6ovDZuNjFg6dtudzJHAmsEM7lRt6WMnf2Ra94c16r1X2WePU7ycYjBVBrxK3//UfmhhHDR0/STO5AJL0kiT6uPoI=
Message-ID: <df47b87a0802290526h322b5cc6va9621e7329d1ac98@mail.gmail.com>
Date: Fri, 29 Feb 2008 15:26:43 +0200
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Reexport init_mm ?
Cc: drago01 <drago01@gmail.com>, "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <47C6617D.1030700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com>
	 <47C6617D.1030700@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 9:23 AM, Chris Snook <csnook@redhat.com> wrote:
> drago01 wrote:
>  > init_mm is no longer exported in 2.6.25, because there are no in tree
>  > modules that use it.
>  > But the closed sources nvidia drivers are using it.
>  > Is it possible to reexport this symbol to let the driver work with this kernel?
>
>  The fact that there are no in-tree modules that use init_mm is rather
>  compelling evidence that it's not a necessary part of the kernel module
>  API.  Nvidia needs to fix their code.  If this is a burden, perhaps they
>  should publish their code under a GPLv2-compatible license so we can
>  show them how to do it.

Publish it and get it merged so you'd have no choice but to keep the
symbol exported in the first place?
