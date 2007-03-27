Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXC0PDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXC0PDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXC0PDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:03:43 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:61055 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905AbXC0PDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:03:42 -0400
X-Greylist: delayed 4146 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 11:03:42 EDT
Date: Tue, 27 Mar 2007 16:54:33 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
Subject: Re: oprofile / selinux / security_port_sid
Message-ID: <20070327135433.xh5mtwgey3pr7u3r@m.safari.iki.fi>
Mail-Followup-To: Stephen Smalley <sds@tycho.nsa.gov>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	James Morris <jmorris@namei.org>,
	Eric Paris <eparis@parisplace.org>
References: <20070327100653.vtmuy64kgkikydlx@m.safari.iki.fi> <1175002823.3864.301.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175002823.3864.301.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 09:40:23 -0400, Stephen Smalley wrote:
> On Tue, 2007-03-27 at 13:06 +0300, Sami Farin wrote:
> > is there room for improvement in security_port_sid() ?
> 
> Yes, lots of room.  Also, it won't get called per-packet if you enable
> secmark (echo 0 > /selinux/compat_net or boot with selinux_compat_net=0
> or build with SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT), although that
> may require updating your policy.

Hmm, test was done with
CONFIG_NETWORK_SECMARK=y
CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=y
and /selinux/compat_net = 0

-- 
Do what you love because life is too short for anything else.

