Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXFTWpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXFTWpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXFTWo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:44:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36866 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbXFTWo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:44:58 -0400
Message-ID: <4679AD0F.3040207@zytor.com>
Date: Wed, 20 Jun 2007 15:41:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: chuck.lever@oracle.com
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk> <4679AB39.4010909@oracle.com>
In-Reply-To: <4679AB39.4010909@oracle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever wrote:
> To support NFS client performance statistics, I recently added
> /proc/self/mountstats.  That might be a place to add details about
> --move and --bind mounts without changing the format of /proc/mounts.

I just looked at /proc/self/mountstats; it seems to have no more
information than /proc/self/mounts, but in an even more annoying format.
 Either I'm missing something, this file doesn't add anything at all.

	-hpa
