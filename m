Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZAGFKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZAGFKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZAGFKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:10:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43287 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZAGFKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:10:34 -0500
Date: Wed, 7 Jan 2009 05:10:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090107051027.GU28946@ZenIV.linux.org.uk>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LKDeQ-0002xz-7E@closure.thunk.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:15:26AM -0500, Theodore Ts'o wrote:
> Or, if that's too complicated, maybe it would be worthwhile to have
> kbuild create its own specialized ccache system?  Note that the last two
> solutions rule out using distcc, unless we can encapsulate the build
> process from a series of Makefile macros to a shell or C program, which
> could then be injected to the remote host system to be executed by
> distcc.  One value of doing that is the CRC or MD5 of the shell script
> could be used as the version tag for the cache system.

Ho-hum...  Could somebody explain why the hell had we switched to this
"intermediate .s" approach, anyway?  It's not as if we couldn't run
objcopy after what we used to do...

BTW, do we care about non-ELF targets at all?
