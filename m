Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYJBRdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYJBRdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 13:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYJBRcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:32:54 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:56246 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYJBRcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YOPha+TyWEZQETk/7Qobj48RR4LLZgzRtXXPSG/XMtChklewVowRFOLZBlRZt4+HAD
         hhdL1fTH7iy0tpnLdLYsQ+r0khd+NfMl5XqHJgB1UAf821U7uNFZNt4XIIVpSlkrKYks
         Kpd9M2I+s5ZPoxglr0GHFiFGgAr5vIlOTKY0s=
Date: Thu, 2 Oct 2008 21:35:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Clark <sclark46@earthlink.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Automatic config file generator
Message-ID: <20081002173523.GA2675@x200.localdomain>
References: <48E4FC91.5010300@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E4FC91.5010300@earthlink.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 12:53:37PM -0400, Stephen Clark wrote:
> Is there a utility that will examine your system and generate a tailored 
> config file so I don't have to compile a zillion modules.
>
> Currently when I want to build the latest kernel I take the config file from
> my distro, (fedora), but it has every module in the world. So on my
> 1.8ghz core 2 duo laptop it takes about 30 min to build a new kernel.

Switch CONFIG_DEBUG_INFO off.

Anyway, trim your config once with big switch-offs like
CONFIG_INFINIBAND=n or CONFIG_ISDN=n (or something like that) then use
old mainline config when upgrading to new mainline kernel with
"make oldconfig". You'll answer small amount of questions every time because of
new options and developers try very hard to ensure oldconfig always
leaves valid working configuration.

Even more, turn on /proc/config.gz feature to never lose your config.
