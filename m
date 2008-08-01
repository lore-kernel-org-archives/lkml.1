Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYHATX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYHATX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYHATXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:23:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39880 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYHATXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:23:48 -0400
Subject: Re: Per-instance devpts
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <48935205.3090807@zytor.com>
References: <20080412172933.GA19295@us.ibm.com>
	 <1208027215.28187.17.camel@x61.ebiederm.org>  <48935205.3090807@zytor.com>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 12:23:44 -0700
Message-Id: <1217618624.20260.50.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 11:12 -0700, H. Peter Anvin wrote:
> 1. /dev/ptmx would have to change to a symlink, ptmx -> pts/ptmx.
...
> I worry #1 would have substantial user-space impact, but I don't see a 
> way around it, since there would be no obvious way to associate 
> /dev/ptmx with a filesystem.

Are your worries just about replacing what is now a normal file with a
symlink, and the behavioral changes that come with that?  

I wonder if using a bind mount for the file would be more robust.  We
wouldn't, of course, be able to do it persistently, but I bet it would
be something we could count on udev to do for us.

-- Dave

