Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbZFJTZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbZFJTZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZFJTZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:25:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZFJTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:25:07 -0400
Date: Wed, 10 Jun 2009 12:25:05 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Harald Dunkel <harald.dunkel@t-online.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: how to stop kernel nfsd?
In-Reply-To: <4A2FE268.60505@t-online.de>
Message-ID: <alpine.DEB.2.01.0906101210040.6439@bogon>
References: <1MDcTI-1elcES0@fwd00.aul.t-online.de> <alpine.DEB.2.01.0906091907340.6439@bogon> <4A2FE268.60505@t-online.de>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/YMLHvok+GGkzFeiooic9hxZjazhDiVHXCpr5
 BJAR+Wk+kEZ/+TcSCsMK0UrPs5vJl/qA2bkRkHORNSwQvq9can
 cBzFgFWFelLXURTyMa09A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009, Harald Dunkel wrote:
> To terminate the nfs service Lenny's /etc/init.d/nfs-kernel-server tries
> 	kill -INT <pid>

Mine does:   start-stop-daemon --stop --name nfsd
...thus sending signal 15 (terminate) to the nfsd processes. Not sure what 
INT does to nfsd.

> Surely I am not asking for support for Lenny's kernel. But it would be
> interesting to know what the kernel nfs daemons are supposed to do when
> they receive a signal. AFAICS this is not documented.

It's called nfs-kernel-server because it communicates with the kernel NFS 
moduels, but it's a userspace issue nonetheless, methinks:

  https://lists.sourceforge.net/lists/listinfo/nfs 

(I justed tested it: kill -INT ends the nfsd processes, but I'm not sure 
if graceful or not...)

HTH,
Christian.
-- 
BOFH excuse #245:

The Borg tried to assimilate your system. Resistance is futile.
