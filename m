Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZKTWJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZKTWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZKTWJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:09:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46151 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754365AbZKTWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:09:25 -0500
Date: Fri, 20 Nov 2009 22:11:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bernd Petrovitsch <bernd@firmix.at>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: O_NOATIME and files in /proc
Message-ID: <20091120221108.1fb1dfcf@lxorguk.ukuu.org.uk>
In-Reply-To: <20091120133651.9df2da80.akpm@linux-foundation.org>
References: <1258477590.16246.35.camel@tara.firmix.at>
	<20091120133651.9df2da80.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 13:36:51 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 17 Nov 2009 18:06:29 +0100
> Bernd Petrovitsch <bernd@firmix.at> wrote:
> 
> > Hi all!
> > 
> > Is there a specific reason that open can not open files (at
> > least /proc/noatime and /proc/cpuinfo) under /proc with NO_ATIME as the
> > following program shows:

Andreww: http://lkml.org/lkml/2004/6/14/184 seems to explain the origin
of this. To follow it further you'd need to discuss it with Ulrich I
imagine and see why glibc expected that behaviour and in turn where it
came from and what security or similar concerns were anticipated.

Alan
