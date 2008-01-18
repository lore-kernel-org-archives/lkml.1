Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbYARQgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbYARQgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761438AbYARQgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:36:36 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:55579 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761404AbYARQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:36:35 -0500
Date: Fri, 18 Jan 2008 08:34:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: rob@landley.net, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation: mention email-clients.txt in
 SubmittingPatches
Message-Id: <20080118083415.07c37f2a.randy.dunlap@oracle.com>
In-Reply-To: <200801181120.03168.michael-lists@free-electrons.com>
References: <200801181120.03168.michael-lists@free-electrons.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 11:20:02 +0100 Michael Opdenacker wrote:

> Applies to 2.6.24-rc8-git2
> 
> I was struggling to get my email-client no to mangle my patch files,
> and I didn't find enough information in the SubmittingPatches file.
> By looking for more information on the web, I eventually found the
> email-clients.txt file, and it answered all my needs
> 
> This patch adds a reference to email-clients.txt in SubmittingPatches,
> and Mozilla related information which is no longer accurate
> (as opposed to the details found in email-clients.txt).
> 
> This should be helpful for people sending their first patches,
> or not sending patches on a frequent basis.
> 
> Michael.
> 
> --
> Signed-off-by: Michael Opdenacker <michael@free-electrons.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> diff -Naur linux-2.6.24-rc8-git2/Documentation/SubmittingPatches linux-2.6.24-rc8-git2-sp/Documentation/SubmittingPatches
> --- linux-2.6.24-rc8-git2/Documentation/SubmittingPatches	2008-01-17 09:48:56.000000000 +0100
> +++ linux-2.6.24-rc8-git2-sp/Documentation/SubmittingPatches	2008-01-18 10:29:46.000000000 +0100
> @@ -220,20 +220,8 @@
>  Exception:  If your mailer is mangling patches then someone may ask
>  you to re-send them using MIME.
>  
> -
> -WARNING: Some mailers like Mozilla send your messages with
> ----- message header ----
> -Content-Type: text/plain; charset=us-ascii; format=flowed
> ----- message header ----
> -The problem is that "format=flowed" makes some of the mailers
> -on receiving side to replace TABs with spaces and do similar
> -changes. Thus the patches from you can look corrupted.
> -
> -To fix this just make your mozilla defaults/pref/mailnews.js file to look like:
> -pref("mailnews.send_plaintext_flowed", false); // RFC 2646=======
> -pref("mailnews.display.disable_format_flowed_support", true);
> -
> -
> +See Documentation/email-clients.txt for hints about configuring
> +your e-mail client so that it sends your patches untouched.
>  
>  8) E-mail size.
>  
> 
> -- 

---
~Randy
