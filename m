Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZLAQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZLAQM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZLAQMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:12:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:42048 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbZLAQMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:12:24 -0500
Message-ID: <4B15406D.6010800@suse.cz>
Date: Tue, 01 Dec 2009 17:12:29 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tony Finch <dot@dotat.at>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCHv2] unifdef: update to upstream revision 1.190
References: <4B151704.7020102@suse.cz>    <20091127210408.GA16310@merkur.ravnborg.org>    <E1NE3M6-0003Za-OJ@hermes-1.csi.cam.ac.uk>    <20091127181749.GA16177@merkur.ravnborg.org>    <alpine.LSU.2.00.0911271901430.6581@hermes-1.csi.cam.ac.uk> <E1NFU0t-0002UG-0R@hermes-1.csi.cam.ac.uk>
In-Reply-To: <E1NFU0t-0002UG-0R@hermes-1.csi.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2009 16:50, Tony Finch wrote:
> Fix handling of input files (e.g. with no newline at EOF) that could
> make unifdef get into an unexpected state and call abort().
> 
> The new -B option compresses blank lines around a deleted section
> so that blank lines around "paragraphs" of code don't get doubled.
> 
> The evaluator can now handle macros with arguments, and unbracketed
> arguments to the "defined" operator.
> 
> Add myself to MAINTAINERS for unifdef.
> 
> Obtained-from: http://dotat.at/prog/unifdef/
> Signed-off-by: Tony Finch <dot@dotat.at>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks, applied. I remove the Obtained-from: line because I didn't find
prior use of it and you list your website in MAINTAINERS anyway. I
assume Sam's ack still holds because the changes you mention are
trivial. BTW, scripts/checkpatch.pl reports some coding style issues
(mostly parentheses in return statements and opening braces directly
after function declarations), but as this is not original kernel source
but a copy of one file from another project, I think we should be
lenient here.

Michal
