Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYAQBRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYAQBRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYAQBRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:17:30 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39257 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYAQBR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:17:29 -0500
Date: Thu, 17 Jan 2008 02:17:27 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Neil Brown <neilb@suse.de>
cc: Karel Zak <kzak@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
In-Reply-To: <18318.41541.386224.301640@notabene.brown>
Message-ID: <Pine.LNX.4.64.0801170214460.31385@fbirervta.pbzchgretzou.qr>
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
 <20080116143051.ec488f3d.akpm@linux-foundation.org> <20080116234339.GG26049@petra.dvoda.cz>
 <Pine.LNX.4.64.0801170057520.31385@fbirervta.pbzchgretzou.qr>
 <18318.41541.386224.301640@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17 2008 11:33, Neil Brown wrote:
>On Thursday January 17, jengelh@computergmbh.de wrote:
>> 
>> On Jan 17 2008 00:43, Karel Zak wrote:
>> >> 
>> >> Seems like a plain bad idea to me.  There will be any number of home-made
>> >> /proc/mounts parsers and we don't know what they do.
>> >
>> > So, let's use /proc/mounts_v2  ;-)
>> 
>> Was not it like "don't use /proc for new things"?
>
>I thought it was "don't use /proc for new things that aren't process
>related".
>
>And as the mount table is per process......

You are right. I'm still in the world where CLONE_NEWNS is not used all
that much in the daily routine, either by the distro or by me.

>In the tradition of stat, statm, status, maybe the former should be
> /proc/$PID/mountm

What next - /proc/pid/mountus? :)
