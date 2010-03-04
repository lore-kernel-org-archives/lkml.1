Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab0CDRmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:42:35 -0500
Received: from fn.samba.org ([216.83.154.106]:56791 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0CDRme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:42:34 -0500
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 12:42:34 EST
Date: Thu, 4 Mar 2010 09:33:45 -0800
From: Jeremy Allison <jra@samba.org>
To: simo <idra@samba.org>
Cc: Jon Severinsson <jon@severinsson.net>, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] [RFC PATCH] CIFS posix acl permission
	checking
Message-ID: <20100304173345.GE18904@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <201003041150.08341.jon@severinsson.net> <1267710262.2375.280.camel@localhost> <201003041621.44577.jon@severinsson.net> <1267717913.2375.298.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267717913.2375.298.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:51:53AM -0500, simo wrote:
> 
> Letting a different user access the mount point *is* a security
> violation in itself. The CIFS security model lies in per user sessions.
> The right way to fix the problem is multi-session mounts. Allowing a
> different user to use a user session is a violation of the security
> model of CIFS.

Multi-session mounts are the only sane fix. This is what Windows
does in their redirectory (when a process with different credentials
traverses into a mount point a new sessionsetup is done to get remote
credentials).

Jeremy.
