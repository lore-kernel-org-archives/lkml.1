Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbXFSXMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbXFSXMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbXFSXMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:12:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbXFSXM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:12:29 -0400
Message-ID: <467862CD.6070009@zytor.com>
Date: Tue, 19 Jun 2007 16:12:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, david@lang.hm,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Chris Snook <csnook@redhat.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <20070619204317.GR10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706191505130.26701@asgard.lang.hm> <4678550D.6070705@zytor.com> <20070619230735.GN14788@delft.aura.cs.cmu.edu>
In-Reply-To: <20070619230735.GN14788@delft.aura.cs.cmu.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Harkes wrote:
> 
> Still, anything that depends on increasing the length of file or path
> names to refer to different versions will encounter problems for long
> file names and deep paths because there is an upper limit on file and
> path name lengths.
> 

Then you have the Solaris variant -- rely on openat() flags to decend
into another namespace.

	-hpa
