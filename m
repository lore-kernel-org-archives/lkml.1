Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYJ0MAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYJ0MAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 08:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYJ0MAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:00:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:52216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYJ0MAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vyY7lTaq/UtCcO0bVl42kjR09Ld9btb4DsKmv3I+M8SSlNy4Ix/zm1W8kOFZWUqeUe
         Oqkxxil/t9Tn4lxx9yOEJNTifwYruIaPjgT9fx/DySCVax7a9LpfyVfqsbotXoiYP0FK
         nTLYLxehZ5z4RwcYVN2htOX4yG5EOrh0ScU7Y=
Message-ID: <4905AD3A.3010706@gmail.com>
Date: Mon, 27 Oct 2008 12:59:54 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28-rc2 regression] hangs on wakeup from s2ram
References: <1225106897.5125.6.camel@localhost>
In-Reply-To: <1225106897.5125.6.camel@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2008 12:28 PM, Soeren Sonnenburg wrote:
> Dear all,
> 
> my macbook pro 1,1 suspends nicely (s2ram) but on wakeup I see a black
> screen...
> 
> Does anyone else observe this? As this was from within X (and it still
> works in .27) I cannot give more details without further investigations
> from the cmdline...

Most distros switch to a console and even after that do suspend (if not, just
try it from console). Do you see any traces when you add no_console_suspend to
the kernel command line?
