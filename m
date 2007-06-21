Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbXFUXR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbXFUXR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXFUXRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:17:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:64296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXFUXRU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:17:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "C. Scott Ananian" <cscott@laptop.org>
Subject: Re: inotify and /proc?
Date: Fri, 22 Jun 2007 01:17:09 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <c6d9bea0706211254r6d457e36wfb3722880a3b4abd@mail.gmail.com>
In-Reply-To: <c6d9bea0706211254r6d457e36wfb3722880a3b4abd@mail.gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706220117.09966.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19flSmXK3MT5L54ryL6DfUInxpRL0Iz3l9Q3Cd
 BYOUukEDCF5ZcwGOCIxqOMJiECgc8CoVnZV7+FYANWep/gMWIp
 kZUbmibtzLpqk5yb21fEw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007, C. Scott Ananian wrote:
> 
> I'd like to make a read-only /proc file which supports inotify -- that
> is, the kernel can send change notifications to userland via the
> inotify mechanism.  I've found fsnotify_modify() (in
> include/linux/fsnotify.h) which seems to do what I want, but it takes
> a struct dentry * -- how can I get a dentry from a struct
> proc_dir_entry and increment its ref count to keep it around?  Any
> help would be appreciated.  Thanks!

It sounds a little fishy to want that in the first place. If we wanted
inotify on /proc, it should work on all files I guess, but that's
an immense amount of work.

What file are you talking about in particular?
Why does it have to be in /proc?
Why not use another notification mechanism -- blocking read(), poll(),
uevent, ...?

	Arnd <><
