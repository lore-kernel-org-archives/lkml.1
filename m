Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbXGRUNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbXGRUNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbXGRUMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:12:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:43807 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbXGRUMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:12:53 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <gregkh@suse.de>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
References: <20070715124232.4e371bf9@hyperion.delvare>
	<20070717034844.GB11602@suse.de>
	<20070717131255.71b7e72e@hyperion.delvare>
	<20070717183652.GG9702@suse.de>
	<20070717230530.64d9a896@hyperion.delvare>
	<20070718033828.GA8582@suse.de>
	<20070718220652.15ad2c4b@hyperion.delvare>
X-Yow: Yow!  Am I having fun yet?
Date: Wed, 18 Jul 2007 22:12:52 +0200
In-Reply-To: <20070718220652.15ad2c4b@hyperion.delvare> (Jean Delvare's
	message of "Wed\, 18 Jul 2007 22\:06\:52 +0200")
Message-ID: <jeir8hqxmj.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali@linux-fr.org> writes:

> On Tue, 17 Jul 2007 20:38:28 -0700, Greg KH wrote:
>>                                            Isn't there some glibc
>> function that can detect the mount point of a filesystem or directory?
>> Something in glibc parses /proc/mounts for something, I can't remember
>> what it is right now though, sorry.
>
> Maybe getmntent(3)? Sure I could use this, but how expensive compared
> to a single stat(2).

How about comparing the device numbers of /sys and its parent?  If they
are different then /sys is a mount point.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
