Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXH3OMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXH3OMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXH3OMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:12:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42081 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbXH3OMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:12:48 -0400
Date: Thu, 30 Aug 2007 16:12:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: NFS4 authentification / fsuid
Message-ID: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


with NFS3, there is this 'root hole', i.e. any person who has a root 
account (perhaps by use of a laptop) can mount an export (let's say this 
export had the "root_squash" option), and still have a look at the user 
files, because he can locally setuid() into another user.

So I was looking for alternatives. CIFS is my favorite candidate, but it 
has a few issues right now. So does sshfs and about everything I have 
come across. Since I remember NFS4 can use KRB5 authentification, my 
question is, will the NFS(4) server process run with an fsuid equal to 
the user that authenticated?


thanks,
	Jan
-- 
