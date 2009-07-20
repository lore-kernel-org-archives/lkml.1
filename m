Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZGTMAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZGTMAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZGTMAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:00:07 -0400
Received: from pigeon.axelspringer.pl ([195.177.210.68]:55312 "EHLO
	mx1.axelspringer.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZGTMAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:00:01 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 08:00:01 EDT
X-Virus-and-Spam-Scanned: amavisd-new-2.6.3 (20090422) + SpamAssassin +
	Kaspersky Anti-Virus + ClamAV + FuzzyOcr @ axelspringer.pl
Message-ID: <4A645A45.9060509@ans.pl>
Date: Mon, 20 Jul 2009 13:51:33 +0200
From: Krzysztof Oledzki <olel@ans.pl>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
References: <20090720040655.GA11940@kroah.com>
In-Reply-To: <20090720040655.GA11940@kroah.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-07-20 06:06, Greg KH wrote:
> I'm announcing the release of the 2.6.27.26 kernel.  All users of the
> 2.6.27 kernel series are very strongly encouraged to upgrade.
> 
> I'll also be replying to this message with a copy of the patch between
> 2.6.27.26 and 2.6.27.27
> 
> The updated 2.6.27.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary
> 
> thanks,

<CUT>
> Linus Torvalds (1):
>       Don't use '-fwrapv' compiler option: it's buggy in gcc-4.1.x

I'm very sorry to say that but 2.6.27.27 compiled with gcc-4.2.4 hangs 
during boot and it is caused by this fix.

I extended http://bugzilla.kernel.org/show_bug.cgi?id=13012 with 
additional info & .config.

Best regards,

				Krzysztof Olêdzki
