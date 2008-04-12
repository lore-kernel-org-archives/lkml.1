Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYDLTeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYDLTeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbYDLTec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:34:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40361 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749AbYDLTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:34:31 -0400
Message-ID: <48010DBD.6010903@zytor.com>
Date: Sat, 12 Apr 2008 12:30:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Multiple instances of devpts
References: <20080412172933.GA19295@us.ibm.com>	 <20080412183514.GO9785@ZenIV.linux.org.uk>  <48010583.3020403@zytor.com> <1208027757.28187.25.camel@x61.ebiederm.org> <48010C70.2030902@zytor.com>
In-Reply-To: <48010C70.2030902@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Thinking about it further, allowing this restriction would also allow a 
> whole lot of cleanups inside the pty setup, since it would eliminate the 
> need to do a separate lookup to find the corresponding devpts entry in 
> pty_open().  The benefit here comes from the closer coupling between the 
> pty and the devpts filesystem and isn't at all related to namespaces, 
> but it's a very nice side benefit.
> 

Minor correction: the lookup is actually in init_dev() in tty_io.c; I'm 
specifically referring to devpts_get_tty().

	-hpa
