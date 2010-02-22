Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0BVQXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:23:50 -0500
Received: from xenotime.net ([72.52.64.118]:39535 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753802Ab0BVQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:23:49 -0500
Message-ID: <4B82AF92.2050106@xenotime.net>
Date: Mon, 22 Feb 2010 08:23:46 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/06] update email client doc about gmail
References: <20100222141907.GA9028@darkstar>
In-Reply-To: <20100222141907.GA9028@darkstar>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/10 06:19, Dave Young wrote:
> Gmail web gui does not work for sending patches now even with firefox
> "view source with" extension. It will use windows style line breaks
> to wrap lines automatically when sening email.
> 
> Rewrite the gmail web gui part of email client documentation.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> ---
>  Documentation/email-clients.txt |   24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
> 
> --- linux-2.6.orig/Documentation/email-clients.txt	2010-02-16 17:11:38.000000000 +0800
> +++ linux-2.6/Documentation/email-clients.txt	2010-02-16 17:23:32.000000000 +0800
> @@ -216,26 +216,14 @@ Works.  Use "Insert file..." or external
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  Gmail (Web GUI)
>  
> -If you just have to use Gmail to send patches, it CAN be made to work.  It
> -requires a bit of external help, though.
> +Does not work for sending patches.
>  
> -The first problem is that Gmail converts tabs to spaces.  This will
> -totally break your patches.  To prevent this, you have to use a different
> -editor.  There is a firefox extension called "ViewSourceWith"
> -(https://addons.mozilla.org/en-US/firefox/addon/394) which allows you to
> -edit any text box in the editor of your choice.  Configure it to launch
> -your favorite editor.  When you want to send a patch, use this technique.
> -Once you have crafted your messsage + patch, save and exit the editor,
> -which should reload the Gmail edit box.  GMAIL WILL PRESERVE THE TABS.
> -Hoorah.  Apparently you can cut-n-paste literal tabs, but Gmail will
> -convert those to spaces upon sending!
> +Gmail web client converts tabs to spaces automatically.
>  
> -The second problem is that Gmail converts tabs to spaces on replies.  If
> -you reply to a patch, don't expect to be able to apply it as a patch.
> +At the same time it wraps lines every 78 chars with CRLF style line breaks
> +although tab2space problem can be solved with external editor.
>  
> -The last problem is that Gmail will base64-encode any message that has a
> -non-ASCII character.  That includes things like European names.  Be aware.
> -
> -Gmail is not convenient for lkml patches, but CAN be made to work.
> +Another problem is that Gmail will base64-encode any message that has a
> +non-ASCII character. That includes things like European names.


-- 
~Randy
