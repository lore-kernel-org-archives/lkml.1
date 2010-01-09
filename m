Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223Ab0AIAIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0AIAIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994Ab0AIAIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:08:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0AIAIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:08:12 -0500
Message-ID: <4B47C8C7.1010507@zytor.com>
Date: Fri, 08 Jan 2010 16:07:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Michal Marek <mmarek@suse.cz>, Masami Hiramatsu <mhiramat@redhat.com>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>,
       Sergei Trofimovich <slyfox@inbox.ru>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] Makefile: do not override LC_CTYPE
References: <20100108115745.GA14758@sepie.suse.cz> <1262952988-16563-1-git-send-email-mmarek@suse.cz> <20100109000008.GB2319@verge.net.au>
In-Reply-To: <20100109000008.GB2319@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 04:00 PM, Simon Horman wrote:
> 
> Personally I think it would be much better to set the locale explicitly
> as needed, where needed, such as the LC_ALL=C sledgehammer that you
> have inserted into arch/sh/tools. Or at a slightly higher level,
> offer an awk-wrapper, as it seems to be the main (only?) cause of concern.
> 

awk, sed, shell scripts, etc. all have the same problem.

	-hpa
