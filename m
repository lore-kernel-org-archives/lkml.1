Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbXFKNHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbXFKNHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXFKNGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:06:51 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:44185 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXFKNGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:06:50 -0400
Date: Mon, 11 Jun 2007 09:06:47 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Tobias Oed <tobias.oed@octant-fr.com>
cc: sds@tycho.nsa.gov, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESENT][TRIVIAL][PATCH] SELinux: Use %lu for inode->i_no when
 printing avcs
In-Reply-To: <466D2419.7040106@octant-fr.com>
Message-ID: <Line.LNX.4.64.0706110906280.30847@d.namei>
References: <466D2419.7040106@octant-fr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Tobias Oed wrote:

> Resending this to a wider audience since the first attempt was mangled
> and I haven't heard anything in a week.
> 
> Inode numbers are unsigned long and so need to %lu as format string of
> printf. I have no idea why the __attribute__((format,..)) of 
> audit_log_format
> doesn't give us a warning.
> Compile tested only.
> 
> Signed-off-by: Tobias Oed <tobias.oed@octant-fr.com>

Thanks, tested & applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm




-- 
James Morris
<jmorris@namei.org>
