Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXA0OtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXA0OtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 09:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXA0OtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 09:49:22 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:55287 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXA0OtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 09:49:21 -0500
Date: Sat, 27 Jan 2007 15:47:36 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Janne Karhunen <Janne.Karhunen@gmail.com>, MrUmunhum@popdial.com,
       linux-kernel@vger.kernel.org
Subject: Re: Mounting NFS root FS
In-Reply-To: <1165349565.5742.104.camel@lade.trondhjem.org>
Message-ID: <Pine.LNX.4.61.0701250121410.10972@yvahk01.tjqt.qr>
References: <4571CE06.4040800@popdial.com>  <24c1515f0612040351p6056101frc12db8eb86063213@mail.gmail.com>
  <1165246177.711.179.camel@lade.trondhjem.org>  <200612041912.30527.Janne.Karhunen@gmail.com>
  <Pine.LNX.4.61.0612042100570.29300@yvahk01.tjqt.qr> 
 <1165265229.5698.21.camel@lade.trondhjem.org>  <Pine.LNX.4.61.0612051939180.18570@yvahk01.tjqt.qr>
  <1165347465.5742.88.camel@lade.trondhjem.org>  <Pine.LNX.4.61.0612052059010.18570@yvahk01.tjqt.qr>
 <1165349565.5742.104.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 5 2006 15:12, Trond Myklebust wrote:
>On Tue, 2006-12-05 at 20:59 +0100, Jan Engelhardt wrote:
JE>>>> Since we're on the topic locking, is it because I am not running
JE>>>> statd on the client that my NFS client hangs during boot phase?
TM>>>
TM>>>If you have applications that try to set locks before rpc.statd is up
TM>>>and running, then that would explain it.
JE>> 
JE>>Even if the nfs mount is mounted using -o ro,nolock?
TM>
TM>No. The 'nolock' option means that the NFS client will use the VFS posix
TM>locks only, which will not depend on rpc.statd.
TM>

By trying a little I found out that it is unionfs which has problems 
with locking.
So on the NFS side (nfs-only, no unionfs above it) all is fine.


	-`J'
-- 
