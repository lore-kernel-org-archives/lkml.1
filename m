Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYH1AIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYH1AIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYH1AIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:08:46 -0400
Received: from tundra.namei.org ([65.99.196.166]:52420 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbYH1AIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:08:45 -0400
Date: Thu, 28 Aug 2008 10:05:09 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andreas Gruenbacher <agruen@suse.de>,
       "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
In-Reply-To: <31237.1219871686@redhat.com>
Message-ID: <alpine.LRH.1.10.0808281004170.18937@tundra.namei.org>
References: <20080827185845.GA25669@us.ibm.com> <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com> <200808271857.48651.agruen@suse.de> <31237.1219871686@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, David Howells wrote:

>  (2) Neuter sys_capset().  I've been holding this off for the next merge
>      window as it isn't a bugfix, unlike (1).  Perhaps I should ask James to
>      push it to Linus.  James?

Linus only pulled the PF_SUPERPRIV fix once the sys_capset change was 
removed from the patch.  It really does need to be a bugfix at this stage.


- James
-- 
James Morris
<jmorris@namei.org>
