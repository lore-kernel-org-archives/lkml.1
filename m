Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0CLBxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 20:53:22 -0500
Received: from fn.samba.org ([216.83.154.106]:38428 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0CLBxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 20:53:21 -0500
Date: Thu, 11 Mar 2010 17:53:19 -0800
From: Jeremy Allison <jra@samba.org>
To: Michael Adam <obnox@samba.org>
Cc: Jeff Layton <jlayton@samba.org>, Jon Severinsson <jon@severinsson.net>,
       linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, vl@samba.org
Subject: Re: [linux-cifs-client] [RFC PATCH] CIFS posix acl permission
	checking
Message-ID: <20100312015319.GC27697@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <201003041150.08341.jon@severinsson.net> <20100304111812.6af53003@barsoom.rdu.redhat.com> <E1Npr8D-00A474-O0@intern.SerNet.DE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Npr8D-00A474-O0@intern.SerNet.DE>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 11:45:29PM +0100, Michael Adam wrote:
> 
> When discussing this with Volker today, he had a different idea:
> One could implement a trans2 impersonate call in samba (as a new
> call in the unix extensions) that could be used to transfer the
> session established by the privileged user (root, say) to a
> different user specified as an argument to the call -- without
> the need to give credentials! Then this call could be used in
> the multi user mount scenario: when uid 1000 accesse the cifs
> mount then the root-dispatcher mount would create a new session
> initially as root and issue an impersonate call to user 1000
> directly afterwards.
> 
> Wouldn't that be something worth considering?

This world work, but protocol cleanliness-wise it's
*really* horrible :-).

Jeremy.
