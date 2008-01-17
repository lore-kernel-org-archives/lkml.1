Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYAQALL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYAQALL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYAQAKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:10:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYAQAKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:10:54 -0500
Date: Wed, 16 Jan 2008 16:09:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Karel Zak <kzak@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
Message-Id: <20080116160930.28168da3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0801170057520.31385@fbirervta.pbzchgretzou.qr>
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
	<20080116143051.ec488f3d.akpm@linux-foundation.org>
	<20080116234339.GG26049@petra.dvoda.cz>
	<Pine.LNX.4.64.0801170057520.31385@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 00:58:06 +0100 (CET) Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Jan 17 2008 00:43, Karel Zak wrote:
> >> 
> >> Seems like a plain bad idea to me.  There will be any number of home-made
> >> /proc/mounts parsers and we don't know what they do.
> >
> > So, let's use /proc/mounts_v2  ;-)
> 
> Was not it like "don't use /proc for new things"?

Well yeah.  If we're going to do a brand new mechanism to expose
per-mount data then we should hunker down and get it right.
